class Badge < ActiveRecord::Base
  acts_as_paranoid

  validates_property :mime_type, of: :image,
                     in: ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/svg', 'application/octet-stream'],
                     if: :image_changed?
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?

  has_and_belongs_to_many :users
end