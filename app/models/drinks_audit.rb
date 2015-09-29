
class DrinksAudit < ActiveRecord::Base
  default_scope ->{ order('drinks_audits.created_at DESC').order(:drink_id) }
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


  #
  # Statistics
  # ----------
  #

  # == Get amount of all drinks sold within
  #    a time range or starting from the beginning
  def self.total_drinks(start_date = nil, end_date = nil)
  
    if ( start_date != nil && end_date != nil )
      @audits = self.where( 
        "DATE(created_at) >= :start_date AND DATE(created_at) <= :end_date",
        start_date: start_date,
        end_date:   end_date
      )
    else
      @audits = self.all
    end


    @audits = @audits.select(
      'COUNT(1) AS drinks_count, drink_id, drinks.name',
    )
      .joins(:drink)
      .group('drink_id')
  end

end


