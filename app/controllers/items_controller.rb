class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :identificate_user, only: [:edit, :update, :destroy]
  before_action :soldout_item, only: [:edit, :update, :destroy]

  def index
    @items = Item.order(created_at: 'DESC')
  end

  def show
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
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item.id)
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  private

  def item_params
    params.require(:item).permit(:name, :info, :price, :category_id, :condition_id, :fee_allocation_id, :prefecture_id,
                                 :delivery_period_id, :image).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def identificate_user
    redirect_to root_path unless current_user.id == @item.user_id
  end

  def soldout_item
    redirect_to root_path if @item.order.present?
  end
end
