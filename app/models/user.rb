class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 2 }
  validates :surname, presence: true, length: { minimum: 2 }
  validates :password, presence: true, length: { minimum: 4 }
  validates :password_confirmation, presence: true

  has_many :petitions
  has_many :votes

  def user_name
    "#{name} #{surname}"
  end

end