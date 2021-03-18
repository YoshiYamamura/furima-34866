class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  alphabet_number_mix = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  full_width_japanese = /\A[ぁ-んァ-ヶ一-龥々]+\z/
  full_width_katakana = /\A[ァ-ヶ]+\z/

  with_options presence: true do
    validates :nickname
    with_options format: { with: full_width_japanese, message: 'は、漢字 or ひらがな or カタカナ（全角）を入力してください' } do
      validates :family_name
      validates :first_name
    end
    with_options format: { with: full_width_katakana, message: 'は、カタカナ（全角）を入力してください' } do
      validates :family_name_kana
      validates :first_name_kana
    end
    validates :birth
    validates :password, format: { with: alphabet_number_mix, message: 'は、英数混合で入力してください' }
  end

  has_many :items
  has_many :orders
end
