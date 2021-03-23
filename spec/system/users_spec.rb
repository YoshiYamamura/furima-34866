require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context '正常系' do 
    it '正しい情報を入力するとユーザー新規登録が出来てトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: @user.nickname
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation
      fill_in 'last-name', with: @user.family_name
      fill_in 'first-name', with: @user.first_name
      fill_in 'last-name-kana', with: @user.family_name_kana
      fill_in 'first-name-kana', with: @user.first_name_kana
      select(@user.birth.year, from: 'user_birth_1i')
      select(@user.birth.month, from: 'user_birth_2i')
      select(@user.birth.day, from: 'user_birth_3i')
      # 会員登録ボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        click_on('会員登録')
      }.to change { User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログインユーザーのニックネームや、ログアウトボタンが表示されることを確認する
      expect(page).to have_content(@user.nickname)
      expect(page).to have_content('ログアウト')
      # 新規登録ページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context '異常系' do
    it '誤った情報ではユーザー新規登録が出来ず新規登録ページに戻る' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する(空欄)
      fill_in 'nickname', with: ''
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      fill_in 'password-confirmation', with: ''
      fill_in 'last-name', with: ''
      fill_in 'first-name', with: ''
      fill_in 'last-name-kana', with: ''
      fill_in 'first-name-kana', with: ''
      select('--', from: 'user_birth_1i')
      select('--', from: 'user_birth_2i')
      select('--', from: 'user_birth_3i')
      # 会員登録ボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        click_on('会員登録')
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq('/users')
      # エラーメッセージが表示されることを確認する
      expect(page).to have_content('ニックネームを入力してください')
    end
  end
end

RSpec.describe 'ログイン・ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context '正常系' do 
    it '正しい情報を入力するとログイン、ログアウトが出来る' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ移動する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      # ログインボタンを押す
      click_on('ログイン')
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログインユーザーのニックネームや、ログアウトボタンが表示されることを確認する
      expect(page).to have_content(@user.nickname)
      expect(page).to have_content('ログアウト')
      # 新規登録ページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
      # ログアウトボタンを押す
      click_on('ログアウト')
      # ログインユーザーのニックネームや、ログアウトボタンが表示されていないことを確認する
      expect(page).to have_no_content(@user.nickname)
      expect(page).to have_no_content('ログアウト')
      # 新規登録ページへ遷移するボタンや、ログインページへ遷移するボタンが表示ていることを確認する
      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
    end
  end
  context '異常系' do 
    it '誤った情報ではログインが出来ずログインページに留まる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ移動する
      visit new_user_session_path
      # ユーザー情報を入力する（空欄）
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      # ログインボタンを押す
      click_on('ログイン')
      # ログインページに留まっていることを確認する
      expect(current_path).to eq(new_user_session_path)
      # エラーメッセージが表示されることを確認する
      expect(page).to have_content('Eメールまたはパスワードが違います')
    end
  end
end
