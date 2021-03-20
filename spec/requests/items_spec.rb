require 'rails_helper'
describe ItemsController, type: :request do

  before do
    @item = FactoryBot.create(:item)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      get root_path
      expect(response).to have_http_status(200)
    end
    it 'indexアクションにリクエストするとレスポンスに出品された商品の商品名が存在する' do
      get root_path
      expect(response.body).to include(@item.name)
    end
    it 'indexアクションにリクエストするとレスポンスに出品された商品の販売価格が存在する' do
      get root_path
      expect(response.body).to include(@item.price.to_s)
    end
    it 'indexアクションにリクエストするとレスポンスに出品された商品の配送料の負担が存在する' do
      get root_path
      expect(response.body).to include(FeeAllocation.data[@item.fee_allocation_id - 1][:name])
    end
    it 'indexアクションにリクエストするとレスポンスに出品された商品の画像URLが存在する' do
      get root_path
      expect(response.body).to include(url_for(@item.image))
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get item_path(@item)
      expect(response).to have_http_status(200)
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の商品名が存在する' do
      get item_path(@item)
      expect(response.body).to include(@item.name)
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の販売価格が存在する' do
      get item_path(@item)
      expect(response.body).to include(@item.price.to_s(:delimited))
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の説明が存在する' do
      get item_path(@item)
      expect(response.body).to include(@item.info)
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の出品者名が存在する' do
      get item_path(@item)
      expect(response.body).to include(@item.user.nickname)
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品のカテゴリーが存在する' do
      get item_path(@item)
      expect(response.body).to include(Category.data[@item.category_id - 1][:name])
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の商品の状態が存在する' do
      get item_path(@item)
      expect(response.body).to include(Condition.data[@item.condition_id - 1][:name])
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の配送料の負担が存在する' do
      get item_path(@item)
      expect(response.body).to include(FeeAllocation.data[@item.fee_allocation_id - 1][:name])
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の発送元の地域が存在する' do
      get item_path(@item)
      expect(response.body).to include(Prefecture.data[@item.prefecture_id - 1][:name])
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の発送日の目安が存在する' do
      get item_path(@item)
      expect(response.body).to include(DeliveryPeriod.data[@item.delivery_period_id - 1][:name])
    end
    it 'showアクションにリクエストするとレスポンスに出品された商品の画像URLが存在する' do
      get item_path(@item)
      expect(response.body).to include(url_for(@item.image))
    end
  end

  describe 'GET #category' do
    it 'categoryアクションにリクエストすると正常にレスポンスが返ってくる' do
      get category_items_path(category_id: @item.category_id)
      expect(response).to have_http_status(200)
    end
    it 'categoryアクションにリクエストするとレスポンスに出品された商品のカテゴリーが存在する' do
      get category_items_path(category_id: @item.category_id)
      expect(response.body).to include(Category.data[@item.category_id - 1][:name])
    end
    it 'categoryアクションにリクエストするとレスポンスに出品された商品の商品名が存在する' do
      get category_items_path(category_id: @item.category_id)
      expect(response.body).to include(@item.name)
    end
    it 'categoryアクションにリクエストするとレスポンスに出品された商品の販売価格が存在する' do
      get category_items_path(category_id: @item.category_id)
      expect(response.body).to include(@item.price.to_s)
    end
    it 'categoryアクションにリクエストするとレスポンスに出品された商品の配送料の負担が存在する' do
      get category_items_path(category_id: @item.category_id)
      expect(response.body).to include(FeeAllocation.data[@item.fee_allocation_id - 1][:name])
    end
    it 'categoryアクションにリクエストするとレスポンスに出品された商品の画像URLが存在する' do
      get category_items_path(category_id: @item.category_id)
      expect(response.body).to include(url_for(@item.image))
    end
  end
end
