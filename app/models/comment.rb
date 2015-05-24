class Comment < ActiveRecord::Base
  acts_as_paranoid
  dragonfly_accessor :photo

  validates :content, presence: true

  belongs_to :post
  belongs_to :user
end
