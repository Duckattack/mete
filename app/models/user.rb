class User < ActiveRecord::Base
  default_scope ->{order('LOWER(name)')}
  validates_presence_of :name


  after_save do |user|
    Audit.create! difference: user.balance - user.balance_was
  end

  def self.balance_sum
    self.sum(:balance)
  end

  def deposit(amount)
    self.balance += amount
    save!
  end

  def payment(amount)
    self.balance -= amount
    save!
  end


  def purchase(drink)
    self.balance -= drink.price 
    audit = DrinksAudit.new :drink => drink
    audit.save
  end

  def purchase!(drink)
    self.purchase(drink)
    self.save!
  end


end
