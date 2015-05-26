class Comment < ActiveRecord::Base
  extend ActsAsTree::TreeWalker
  attr_accessor :comments

  acts_as_paranoid
  dragonfly_accessor :photo
  acts_as_tree order: 'created_at'

  validates :content, presence: true

  belongs_to :post
  belongs_to :user
end
