class Organization < ActiveRecord::Base
  acts_as_paranoid
  has_secure_password
  dragonfly_accessor :image

  validates :web_url, allow_nil: true, allow_blank: true, format: { with: /(https?|ftp|file|ssh):\/\// }
  validates :facebook_link, allow_nil: true, allow_blank: true, format: { with: /(https?|ftp|file|ssh):\/\// }
  validates :twitter_link, allow_nil: true, allow_blank: true, format: { with: /(https?|ftp|file|ssh):\/\// }
  validates :google_link, allow_nil: true, allow_blank: true, format: { with: /(https?|ftp|file|ssh):\/\// }

  validates_property :mime_type, of: :image,
                     in: ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/svg', 'application/octet-stream'],
                     if: :image_changed?
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?

  has_and_belongs_to_many :communities
  has_many :posts
  has_and_belongs_to_many :users
  has_many :comments
  has_many :subscribers, :class_name => "Subscriber", :foreign_key => "organization_id"
  has_many :facebook_subscriptions
  has_one :location

  before_save :set_slug
  before_update :set_slug

  def to_param
    slug
  end

  def set_slug
    # Remove non-alphanumeric characters, but leave spaces.  Then replaces spaces with '-'.
    self.slug = name.downcase.gsub(/[^a-z0-9\s]/i, '').gsub(' ', '-').gsub('.', '')
  end

  def create_location(params)
    loc = Location.new.set_location_attrs(Location.new, params)
    self.location = loc
  end

  def as_json(options={})
    super(:only => [
              :id,
              :name,
              :description,
              :email,
              :created_at,
              :created_by,
              :facebook_link,
              :twitter_link,
              :google_link,
              :web_url,
              :image_name,
              :image_url,
              :color,
              :slug
          ], :include => {
             :location => {
                 :only => [
                     :id,
                     :lat,
                     :lon,
                     :name,
                     :address,
                     :city,
                     :state,
                     :postcode,
                     :county,
                     :country
                 ]
             },
           })
  end
end
