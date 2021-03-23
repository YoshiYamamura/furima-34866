require 'rails_helper'

RSpec.describe '商品出品機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end
  context '正常系' do 
    it 'ログインユーザーが正しい情報を入力すると、商品の出品が出来る' do
      # ログインする
      sign_in(@user)
      # 商品出品ボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページへ移動する
      visit new_item_path
      # 商品情報を入力する
      #attach_file('item[image]', url_for(@item.image)) #認証付URLにリダイレクトされ画像取得できない
      attach_file('item[image]', 'public/images/test_image.jpeg')
      fill_in 'item-name', with: @item.name
      fill_in 'item-info', with: @item.info
      select(@item.category.name, from: 'item-category')
      select(@item.condition.name, from: 'item-sales-status')
      select(@item.fee_allocation.name, from: 'item-shipping-fee-status')
      select(@item.prefecture.name, from: 'item-prefecture')
      select(@item.delivery_period.name, from: 'item-scheduled-delivery')
      fill_in 'item-price', with: @item.price
      # 出品するボタンを押すとItemモデルのカウントが1上がることを確認する
      expect{
        click_on('出品する')
      }.to change { Item.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページに出品した商品の商品名、販売価格、配送料の負担、画像があることを確認する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price)
      expect(page).to have_content(@item.fee_allocation.name)
      expect(page).to have_selector('.item-img')
    end
  end
  context '異常系' do 
    it 'ログインユーザーが誤った情報を入力すると、商品出品が出来ず商品出品ページに戻る' do
      # ログインする
      sign_in(@user)
      # 商品出品ボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページへ移動する
      visit new_item_path
      # 商品情報を入力する（空欄）
      fill_in 'item-name', with: ''
      fill_in 'item-info', with: ''
      select('--', from: 'item-category')
      select('--', from: 'item-sales-status')
      select('--', from: 'item-shipping-fee-status')
      select('--', from: 'item-prefecture')
      select('--', from: 'item-scheduled-delivery')
      fill_in 'item-price', with: ''
      # 出品するボタンを押してもItemモデルのカウントは上がらないことを確認する
      expect{
        click_on('出品する')
      }.to change { Item.count }.by(0)
      # 商品出品ページへ戻されることを確認する
      expect(current_path).to eq('/items')
      # エラーメッセージが表示されることを確認する
      expect(page).to have_content('画像を入力してください')
    end
    it 'ログインしていないユーザーは、商品出品ページに遷移出来ずログインページにリダイレクトされる' do
      # トップページに移動する
      visit root_path
      # 商品出品ボタンを押す
      click_on('出品する')
      # ログインページにリダイレクトされることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end  
end

RSpec.describe '商品一覧・詳細機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
  end
  context '正常系' do
    it '出品されている商品の一覧・詳細ページが表示される' do
      # トップページへ移動する
      visit root_path
      # 出品されている商品の商品名、販売価格、配送料の負担、画像が一覧表示されていることを確認する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price.to_s)
      expect(page).to have_content(@item.fee_allocation.name)
      expect(page).to have_selector('.item-img')
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 出品している商品の商品名、商品の説明、販売価格、出品者名、カテゴリー、商品の状態、配送料の負担、発送元の地域、発送日の目安、画像があることを確認する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.info)
      expect(page).to have_content(@item.price.to_s(:delimited))
      expect(page).to have_content(@item.user.nickname)
      expect(page).to have_content(@item.category.name)
      expect(page).to have_content(@item.condition.name)
      expect(page).to have_content(@item.fee_allocation.name)
      expect(page).to have_content(@item.prefecture.name)
      expect(page).to have_content(@item.delivery_period.name)
      expect(page).to have_selector('.item-box-img')
    end
  end
end

RSpec.describe '商品編集機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @edit_item = FactoryBot.build(:item)
  end
  context '正常系' do
    it 'ログインしている出品者が正しい情報を入力すると、商品の編集が出来る' do
      # ログインする
      sign_in(@item.user)
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 商品の編集ボタンがあることを確認する
      expect(page).to have_content('商品の編集')
      # 商品編集ページへ移動する
      visit edit_item_path(@item)
      # 商品情報を変更入力する
      attach_file('item[image]', 'public/images/test_image.jpeg')
      fill_in 'item-name', with: @edit_item.name
      fill_in 'item-info', with: @edit_item.info
      select(@edit_item.category.name, from: 'item-category')
      select(@edit_item.condition.name, from: 'item-sales-status')
      select(@edit_item.fee_allocation.name, from: 'item-shipping-fee-status')
      select(@edit_item.prefecture.name, from: 'item-prefecture')
      select(@edit_item.delivery_period.name, from: 'item-scheduled-delivery')
      fill_in 'item-price', with: @edit_item.price
      # 変更するボタンを押してもItemモデルのカウントが上がらないことを確認する
      expect{
        click_on('変更する')
      }.to change { Item.count }.by(0)
      # 商品詳細ページへ遷移したことを確認する
      expect(current_path).to eq(item_path(@item))
      # 出品している商品の商品名、商品の説明、販売価格、カテゴリー、商品の状態、配送料の負担、発送元の地域、発送日の目安、画像が変更されたことを確認する
      expect(page).to have_content(@edit_item.name)
      expect(page).to have_content(@edit_item.info)
      expect(page).to have_content(@edit_item.price.to_s(:delimited))
      expect(page).to have_content(@edit_item.category.name)
      expect(page).to have_content(@edit_item.condition.name)
      expect(page).to have_content(@edit_item.fee_allocation.name)
      expect(page).to have_content(@edit_item.prefecture.name)
      expect(page).to have_content(@edit_item.delivery_period.name)
      expect(page).to have_selector('.item-box-img')
    end
  end
  context '異常系' do
    it 'ログインしている出品者が誤った情報を入力すると、商品の編集が出来ず商品編集ページに戻る' do
      # ログインする
      sign_in(@item.user)
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 商品の編集ボタンがあることを確認する
      expect(page).to have_content('商品の編集')
      # 商品編集ページへ移動する
      visit edit_item_path(@item)
      # 商品情報を変更入力する（空欄）
      fill_in 'item-name', with: ''
      fill_in 'item-info', with: ''
      select('--', from: 'item-category')
      select('--', from: 'item-sales-status')
      select('--', from: 'item-shipping-fee-status')
      select('--', from: 'item-prefecture')
      select('--', from: 'item-scheduled-delivery')
      fill_in 'item-price', with: ''
      # 変更するボタンを押す
      click_on('変更する')
      # 商品編集ページへ戻されることを確認する
      expect(current_path).to eq("/items/#{@item.id}")
      # エラーメッセージが表示されることを確認する
      expect(page).to have_content('商品名を入力してください')
    end
    it 'ログインしている出品者以外のユーザーは、商品編集ページに遷移出来ずトップページにリダイレクトされる' do
      # ログインする
      another_user = FactoryBot.create(:user)
      sign_in(another_user)
      # 商品編集ページへ移動しようとする
      visit edit_item_path(@item)
      # トップページへリダイレクトされることを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログインしていないユーザーは、商品編集ページに遷移出来ずログインページにリダイレクトされる' do
      # 商品編集ページへ移動しようとする
      visit edit_item_path(@item)
      # ログインページへリダイレクトされることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '商品削除機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
  end
  context '正常系' do
    it 'ログインしている出品者は、商品の削除が出来る' do
      # ログインする
      sign_in(@item.user)
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 削除ボタンがあることを確認する
      expect(page).to have_content('削除')
      # 削除ボタンを押す
      click_on('削除')
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページに出品していた商品の商品名、販売価格がないことを確認する
      expect(page).to have_no_content(@item.name)
      expect(page).to have_no_content(@item.price)
    end
  end
  context '異常系' do
    it 'ログインしている出品者以外のユーザーは、商品の削除が出来ない' do
      # ログインする
      another_user = FactoryBot.create(:user)
      sign_in(another_user)
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 削除ボタンがないことを確認する
      expect(page).to have_no_content('削除')
    end
    it 'ログインしていないユーザーは、商品の削除が出来ない' do
      # トップページに移動する
      visit root_path
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 削除ボタンがないことを確認する
      expect(page).to have_no_content('削除')
    end
  end
end

RSpec.describe 'カテゴリー別表示機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
  end
  context '正常系' do
    it '出品されている商品のカテゴリー別ページが表示される' do
      # トップページへ移動する
      visit root_path
      # ヘッダーのカテゴリーにhoverするとプルダウンメニューが表示されることを確認する
      find('#category-title').hover
      expect(page).to have_content("#{@item.category.name}")
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # カテゴリーをもっと見るリンクがあることを確認する
      expect(page).to have_content("#{@item.category.name}をもっと見る")
      # カテゴリーをもっと見るリンクをクリックする
      click_on("#{@item.category.name}をもっと見る")
      # カテゴリー別ページへ遷移したことを確認する
      expect(current_path).to eq("/items/category")
      # カテゴリー名、出品されている商品の商品名、販売価格、配送料の負担、画像が一覧表示されていることを確認する
      expect(page).to have_content(@item.category.name)
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price.to_s)
      expect(page).to have_content(@item.fee_allocation.name)
      expect(page).to have_selector('.item-img')
    end
  end
end