class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  alphabet_number_mix = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i
  full_width_japanese = /\A[ぁ-んァ-ヶ一-龥々]+\z/
  full_width_katakana = /\A[ァ-ヶ]+\z/

  with_options presence: true do
    validates :nickname
    validates :family_name, format: { with: full_width_japanese }
    validates :first_name, format: { with: full_width_japanese }
    validates :family_name_kana, format: { with: full_width_katakana }
    validates :first_name_kana, format: { with: full_width_katakana }
    validates :birth
    validates :password, format: { with: alphabet_number_mix }
  end
end
