class Petition < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 10 }

  belongs_to :user
  has_many :votes

  def voted_by? (user)
    votes.where(user_id: user.id).any?
  end

end