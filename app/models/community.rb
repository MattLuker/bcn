class Community < ActiveRecord::Base
  acts_as_paranoid
  dragonfly_accessor :image
  #attr_accessor :slug

  validates :name, presence: true, uniqueness: true
  validates_property :ext, of: :image, in: ['jpeg', 'jpg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?
  validates_property :mime_type, of: :image,
                     in: ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/svg'],
                     if: :image_changed?
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?

  has_and_belongs_to_many :posts
  has_and_belongs_to_many :users
  has_many :subscribers, :class_name => "Subscriber", :foreign_key => "community_id"

  scope :popularity, -> { order('posts_count + users_count desc') }

  before_save :set_slug
  before_update :set_slug

  def to_param
    slug
  end

  def set_slug
    # Remove non-alphanumeric characters, but leave spaces.  Then replaces spaces with '-'.
    self.slug = name.downcase.gsub(/[^a-z0-9\s]/i, '').gsub(' ', '-')
  end

  def set_sync_type
    user = User.find(created_by)
    if !(user.facebook_id.nil?) and events_url.match(/facebook/i)
      self.events_sync_type = 'facebook'
    elsif !(events_url.nil?) and events_url.match(/ical/i)
      self.events_sync_type = 'ical'
    end

    unless events_url.nil?

    end
  end

  def as_json(options={})
    super(:only => [
            :id,
            :name,
            :description,
            :home_page,
            :color,
            :created_by
      ],
      :include => {
        :posts => {
          :only => [
            :id,
            :title,
            :description,
          ],
          :include => {
            :locations => {
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
          },
        },
        :users => {
          :only => [
              :id,
              :email,
              :username,
              :first_name,
              :last_name
            ],
          },
        },
    )
  end

  def auto_value
    value = id
    label = name
  end
end
