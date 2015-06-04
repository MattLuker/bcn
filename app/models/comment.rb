class Comment < ActiveRecord::Base
  extend ActsAsTree::TreeWalker
  attr_accessor :comments

  acts_as_paranoid
  dragonfly_accessor :photo
  acts_as_tree order: 'created_at'

  validates :content, presence: true

  belongs_to :post
  belongs_to :user

  before_destroy :raise_children


  def raise_children
    children.each do |child|
      if child.parent.parent
        child.parent_id = child.parent.parent.id
      else
        child.post = child.root.post
        child.parent_id = nil
      end
      child.save
    end
  end
end
