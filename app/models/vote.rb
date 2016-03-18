class Vote < ActiveRecord::Base

  validates :user_id, uniqueness: {scope: :petition_id}
  belongs_to :user
  belongs_to :petition

end