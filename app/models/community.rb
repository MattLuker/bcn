class Community < ActiveRecord::Base
  acts_as_paranoid
  dragonfly_accessor :image

  validates :name, presence: true, uniqueness: true
  validates_property :ext, of: :image, in: ['jpeg', 'jpg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?
  validates_property :mime_type, of: :image,
                     in: ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/svg'],
                     if: :image_changed?
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'svg', 'svgz'], if: :image_changed?

  # after_create do
  #   Log.create({community: self, action: "created"})
  # end
  #
  # after_update do
  #   Log.create({community: self, action: "updated"})
  # end

  #before_save :set_sync_type

  has_and_belongs_to_many :posts
  has_and_belongs_to_many :users
  has_many :subscribers, :class_name => "Subscriber", :foreign_key => "community_id"

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
