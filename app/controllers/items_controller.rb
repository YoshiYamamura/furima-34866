class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @items = Item.order(created_at: 'DESC')
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    redirect_to root_path
  end

  private

  def item_params
    params.require(:item).permit(:name, :info, :price, :category_id, :condition_id, :fee_allocation_id, :prefecture_id,
                                 :delivery_period_id, :image).merge(user_id: current_user.id)
  end
end
