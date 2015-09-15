class DrinksController < ApplicationController
  # GET /drinks
  # GET /drinks.json
  def index
    @drinks = Drink.order(:name).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @drinks }
    end
  end

  # GET /drinks/1
  # GET /drinks/1.json
  def show
    @drink = Drink.find(params[:id])

    respond_to do |format|
      format.html {
        # show.html.erb
      }
      format.json { render json: @drink }
    end
  end

  # GET /drinks/new
  # GET /drinks/new.json
  def new
    @drink = Drink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @drink }
    end
  end

  # GET /drinks/1/edit
  def edit
    @drink = Drink.find(params[:id])
  end

  # POST /drinks
  # POST /drinks.json
  def create
    @drink = Drink.new(drink_params)

    respond_to do |format|
      if @drink.save
        format.html { redirect_to @drink, notice: 'Drink was successfully created.' }
        format.json { render json: @drink, status: :created, location: @drink }
      else
        format.html { render action: "new" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /drinks/1
  # PUT /drinks/1.json
  def update
    @drink = Drink.find(params[:id])

    respond_to do |format|
      if @drink.update_attributes(drink_params)
        format.html { redirect_to @drink, notice: 'Drink was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drinks/1
  # DELETE /drinks/1.json
  def destroy
    @drink = Drink.find(params[:id])
    @drink.destroy

    respond_to do |format|
      format.html { redirect_to drinks_url }
      format.json { head :no_content }
    end
  end


  #
  # POST /drinks/:id/purchase
  # Purchase a drink and debit the users account
  # 
  def purchase
    @drink = Drink.find(params[:id])
    @user  = User.find(params[:user_id]) 
    
    # Debit user and add purchase to drinks audit
    @user.purchase!(@drink)

    respond_to do |format|
      format.html do
        flash[:success] = "You just bought a drink and your new balance is #{@user.balance}. Thank you."
        if (@user.balance < 0) then
          flash[:warning] = "Your balance is below zero. Remember to compensate as soon as possible."
        end
        redirect_to @user 
      end
      format.json do
        render :json => { :success => true, :new_balance => @user.balance.to_s }
      end
    end

  end

  private

  def drink_params
    params.require(:drink).permit(:bottle_size, :caffeine, :price, :logo, :name)
  end

end
