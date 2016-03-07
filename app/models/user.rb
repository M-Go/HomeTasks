class User < ActiveRecord::Base
  validates :email, :name, :surname, :password, presence: true
end