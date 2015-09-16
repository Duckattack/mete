
#
# Drinks Audits Controller
# ------------------------
#
# Query drink audits:
# GET /drinks_audits?start_date=foo&end_date=bar
#

class DrinksAuditsController < ApplicationController

  # List all the audits 
  def index
    if params[:start_date] and params[:end_date]

      @start_date = Date.civil(
        params[:start_date][:year].to_i,
        params[:start_date][:month].to_i,
        params[:start_date][:day].to_i
      )

      @end_date = Date.civil(
        params[:end_date][:year].to_i,
        params[:end_date][:month].to_i,
        params[:end_date][:day].to_i
      )

      @audits = DrinksAudit.where(
        "DATE(created_at) >= :start_date AND DATE(created_at) <= :end_date",
        start_date: @start_date,
        end_date: @end_date
      )

      @grouped_audits = DrinksAudit.grouped.where(
        "DATE(created_at) >= :start_date AND DATE(created_at) <= :end_date",
        start_date: @start_date,
        end_date: @end_date
      )

    else
      @start_date = Date.today
      @end_date   = Date.today

      @audits         = DrinksAudit.all
      @grouped_audits = DrinksAudit.grouped
    end

    @sum          = @audits.count
    @payments_sum = @audits.sum(:price)
  end


end



