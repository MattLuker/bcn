class Comment < ActiveRecord::Base
  acts_as_paranoid

  validates :content, presence: true

  belongs_to :post
  belongs_to :user
end
