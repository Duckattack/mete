
class DrinksAudit < ActiveRecord::Base
  default_scope ->{ order('created_at DESC').order(:drink_id) }
  belongs_to :drink
  
  #
  # Override setter to assign drink id and price
  #
  def drink=(drink)
    self.drink_id = drink.id
    self.price = drink.price
  end


  def self.grouped
    self.select(
      'drinks_audits.*, SUM(1) as count, SUM(price) as total'
    ).group(:drink_id).group('DATE(created_at)')
  end

end


