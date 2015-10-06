class User < ActiveRecord::Base
  default_scope ->{order('LOWER(name)')}
  validates_presence_of :name

  # Add uploadable avatar
  has_attached_file :avatar,
                    :styles => { :thumb => "100x100#" }, 
                    :default_style => :thumb

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


  def gravatar_url
    url = if self.email.present?
         GravatarImageTag::gravatar_url(self.email, {
            :default => 'https://assets.github.com/images/gravatars/gravatar-140.png'
         })
      else
        GravatarImageTag.gravatar_url("", {
          :default => 'https://assets.github.com/images/gravatars/gravatar-140.png'
        })
      end
    return url
  end

  def avatar_url(size = :thumb, prefix = "")
    url = if self.avatar.present?
        prefix + self.avatar.url(size)
      else
        self.gravatar_url
      end

    return url
  end

end
