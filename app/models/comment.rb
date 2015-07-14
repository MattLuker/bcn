class Comment < ActiveRecord::Base
  extend ActsAsTree::TreeWalker
  attr_accessor :comments
  attr_accessor :photo_web_url

  acts_as_paranoid
  dragonfly_accessor :photo
  acts_as_tree order: 'created_at'

  validates :content, presence: true
  validates_property :ext, of: :photo, in: ['jpeg', 'jpg', 'png', 'gif', 'svg', 'svgz', 'JPG', 'PNG'], if: :photo_changed?
  validates_property :mime_type, of: :photo,
                     in: ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/svg'],
                     if: :photo_changed?
  validates_property :format, of: :photo, in: ['jpeg', 'png', 'gif', 'svg', 'svgz'], if: :photo_changed?

  belongs_to :post
  belongs_to :user
  belongs_to :organization

  before_destroy :raise_children

  def as_json(options={})
    self.photo_web_url = self.photo.url if self.photo
    super(methods: :photo_web_url, :only => [
                                     :id,
                                     :content,
                                     :created_at,
                                     :photo_name,
                                     :photo_web_url,
                                     :parent_id
                                 ])
  end


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
