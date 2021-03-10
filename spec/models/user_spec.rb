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
        @user.nickname = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
    end
    context '異常系: family_name, first_name' do
      it 'family_nameが空では登録できない' do
        @user.family_name = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Family name is invalid")
      end
      it 'family_nameが半角では登録できない' do
        @user.family_name = "ﾔﾏﾀﾞ"
        @user.valid?
        expect(@user.errors.full_messages).to include("Family name is invalid")
      end
      it 'first_nameが空では登録できない' do
        @user.first_name = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("First name is invalid")
      end
      it 'first_nameが半角では登録できない' do
        @user.first_name = "ﾀﾛｳ"
        @user.valid?
        expect(@user.errors.full_messages).to include("First name is invalid")
      end
    end
    context '異常系: family_name_kana, first_name_kana' do
      it 'family_name_kanaが空では登録できない' do
        @user.family_name_kana = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Family name kana is invalid")
      end
      it 'family_name_kanaが半角では登録できない' do
        @user.family_name_kana = "ﾔﾏﾀﾞ"
        @user.valid?
        expect(@user.errors.full_messages).to include("Family name kana is invalid")
      end
      it 'family_name_kanaがカタカナ以外では登録できない' do
        @user.family_name_kana = "山田"
        @user.valid?
        expect(@user.errors.full_messages).to include("Family name kana is invalid")
      end
      it 'first_name_kanaが空では登録できない' do
        @user.first_name_kana = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana is invalid")
      end
      it 'first_name_kanaが半角では登録できない' do
        @user.first_name_kana = "ﾀﾛｳ"
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana is invalid")
      end
      it 'first_name_kanaがカタカナ以外では登録できない' do
        @user.first_name_kana = "太郎"
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana is invalid")
      end
    end
    context '異常系: birth' do
      it 'birthが空では登録できない' do
        @user.birth = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth can't be blank")
      end
    end
    context '異常系: email' do
      it 'emailが空では登録できない' do
        @user.email = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it '重複したemailが存在する場合には登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end
      it "emailに@が含まれない場合には登録できない" do
        @user.email = "aaaaa.com"
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end
    end
    context '異常系: password, password_confirmation' do
      it 'passwordが空では登録できない' do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it 'passwordが5文字以下では登録できない' do
        @user.password = "123ab"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
      it 'passwordが半角数字のみでは登録できない' do
        @user.password = "000000"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it 'passwordが半角英字のみでは登録できない' do
        @user.password = "aaaaaa"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it 'passwordが全角では登録できない' do
        @user.password = "１２３Ａｂｃ"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it 'password_confirmationが空では登録できない' do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password_confirmation = "123abc"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
