

#
# Show money transfer form for user to user transactions
# Transfers will be handled
#

class TransfersController < ApplicationController
  before_filter :load_users

  def index
  end

  #
  # Create new transaction:
  # params: 
  # srcUserId, dstUserId, amount
  #
  def create
    @srcUser = User.find(params[:src_user_id].to_i)
    @dstUser = User.find(params[:dst_user_id].to_i)

    @amount = BigDecimal.new(params[:amount])

    # Make deposit from src user
    @srcUser.payment(@amount)

    # Add amount to dst user
    @dstUser.deposit(@amount)

    respond_to do |format|
      format.html do
        flash[:success] = "Transfer from #{@srcUser.name} to #{@dstUser.name} successful."
        redirect_to '/transfers'
      end
      format.json do
        render :json => { :success => true }
      end
    end
  end


  protected
    def load_users
      @users = User.all
    end

end

