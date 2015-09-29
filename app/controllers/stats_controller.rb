
# 
# Statistics Controller
# ---------------------
#
#

class StatsController < ApplicationController

  # Main view
  def index
  end

  # Get amount off all drinks
  def drinks_total 
    @drinks = DrinksAudit.total_drinks
  end

  # Get drinks timeseries
  def drinks_times
    @audits = DrinksAudit.grouped
    
    # Transform series
    @series_map = {}
    @audits.each do |audit|
      if @series_map[audit.drink.name].nil? 
        @series_map[audit.drink.name] = []
      end

      @series_map[audit.drink.name].push [audit.created_at, audit.count]
    end

  end

end

