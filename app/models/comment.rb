class Comment < ActiveRecord::Base
  acts_as_paranoid
  dragonfly_accessor :photo
  acts_as_tree order: 'created_at'

  validates :content, presence: true

  belongs_to :post
  belongs_to :user
  has_many :replies
end
