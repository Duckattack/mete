
class DrinksAudit < ActiveRecord::Base
  default_scope ->{ order('created_at DESC') }
  belongs_to :drink

  
  #
  # Override setter to assign drink id and price
  #
  def drink=(drink)
    self.drink_id = drink.id
    self.price = drink.price
  end

end


