class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url
    else
      render "new"
    end
  end

  # orders can only be processed in the non-saved stated.
  def process_orders
    @items = Item.find(:all, :conditions => ["buyer=? and saved=?",current_user.username,false])
    Item.setToOrdered(@items)
    redirect_to view_cart_path
  end

  def view_orders
    @items = Item.find(:all, :conditions => ["seller=? and order_id=?",current_user.username, 1])
    respond_to do |format|
      format.html # view_orders.html.erb
      format.json { render json: @items }
    end
  end

  def keeper_home
    @items = Item.find(:all, :conditions => ["seller=? and buyer=? and count=?",current_user.username, "none", 1])
    respond_to do |format|
      format.html # keeper_home.html.erb
      format.json { render json: @items }
    end
  end

  def view_cart
    @items = Item.find(:all, :conditions => ["buyer=? and order_id=? and saved=?",current_user.username, 0, false])
    respond_to do |format|
      format.html # view_cart.html.erb
      format.json { render json: @items }
    end
  end

  # Allows a shopper to create a copy of the keeper's item.
  def addToCart
    item = Item.find(params[:id])
    @item = Item.new(:name => item.name, :price => item.price, :seller => item.seller, :buyer => current_user.username, :count => 1, :order_id => 0, :saved => item.saved)
    @item.save
    if @item.save
      redirect_to items_path, :notice => "Item added to Cart"
    else
      render "new"
    end
  end

  def displaySavedItems
    @items = Item.find(:all, :conditions => ["buyer=? and saved=?",current_user.username, true])
    respond_to do |format|
      format.html # saved.html.erb
      format.json { render json: @users }
    end
  end

  def save_cart
    @items = Item.find(:all, :conditions => ["buyer=? and order_id=? and saved=?",current_user.username, 0, false])
    @items.each do |item|
      Item.saveItem(item)
    end
    redirect_to view_cart_path, :notice => 'Entire cart saved'
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
