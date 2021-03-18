require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '正常系' do
      it 'nickname, family_name, first_name, family_name_kana, first_name_kana, birth, email, password, password_confirmationが存在すれば登録できる' do
        expect(@user).to be_valid
      end
    end
    context '異常系: nickname' do
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('ニックネームを入力してください')
      end
    end
    context '異常系: family_name, first_name' do
      it 'family_nameが空では登録できない' do
        @user.family_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('苗字を入力してください')
      end
      it 'family_nameが半角では登録できない' do
        @user.family_name = 'ﾔﾏﾀﾞ'
        @user.valid?
        expect(@user.errors.full_messages).to include('苗字は、漢字 or ひらがな or カタカナ（全角）を入力してください')
      end
      it 'first_nameが空では登録できない' do
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('名前を入力してください')
      end
      it 'first_nameが半角では登録できない' do
        @user.first_name = 'ﾀﾛｳ'
        @user.valid?
        expect(@user.errors.full_messages).to include('名前は、漢字 or ひらがな or カタカナ（全角）を入力してください')
      end
    end
    context '異常系: family_name_kana, first_name_kana' do
      it 'family_name_kanaが空では登録できない' do
        @user.family_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('苗字カナを入力してください')
      end
      it 'family_name_kanaが半角では登録できない' do
        @user.family_name_kana = 'ﾔﾏﾀﾞ'
        @user.valid?
        expect(@user.errors.full_messages).to include('苗字カナは、カタカナ（全角）を入力してください')
      end
      it 'family_name_kanaがカタカナ以外では登録できない' do
        @user.family_name_kana = '山田'
        @user.valid?
        expect(@user.errors.full_messages).to include('苗字カナは、カタカナ（全角）を入力してください')
      end
      it 'first_name_kanaが空では登録できない' do
        @user.first_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('名前カナを入力してください')
      end
      it 'first_name_kanaが半角では登録できない' do
        @user.first_name_kana = 'ﾀﾛｳ'
        @user.valid?
        expect(@user.errors.full_messages).to include('名前カナは、カタカナ（全角）を入力してください')
      end
      it 'first_name_kanaがカタカナ以外では登録できない' do
        @user.first_name_kana = '太郎'
        @user.valid?
        expect(@user.errors.full_messages).to include('名前カナは、カタカナ（全角）を入力してください')
      end
    end
    context '異常系: birth' do
      it 'birthが空では登録できない' do
        @user.birth = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('生年月日を入力してください')
      end
    end
    context '異常系: email' do
      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールを入力してください')
      end
      it '重複したemailが存在する場合には登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end
      it 'emailに@が含まれない場合には登録できない' do
        @user.email = 'aaaaa.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールは不正な値です')
      end
    end
    context '異常系: password, password_confirmation' do
      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end
      it 'passwordが5文字以下では登録できない' do
        @user.password = '123ab'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end
      it 'passwordが半角数字のみでは登録できない' do
        @user.password = '000000'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは、英数混合で入力してください')
      end
      it 'passwordが半角英字のみでは登録できない' do
        @user.password = 'aaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは、英数混合で入力してください')
      end
      it 'passwordが全角では登録できない' do
        @user.password = '１２３Ａｂｃ'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは、英数混合で入力してください')
      end
      it 'password_confirmationが空では登録できない' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password_confirmation = '123abc'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
    end
  end
end
