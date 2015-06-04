class Post < ActiveRecord::Base
  acts_as_paranoid
  dragonfly_accessor :image

  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, allow_nil: true, format: { with: /.*/, message: 'format must look like: 2015-05-25' }
  validates :start_time, allow_nil: true, format: { with: /.*/, message: 'format must look like 05:05' }
  validates :end_date, allow_nil: true, format: { with: /.*/, message: 'format must look like: 2015-05-25' }
  validates :end_time, allow_nil: true, format: { with: /.*/, message: 'format must look like 05:05' }

  belongs_to :user
  has_many :locations
  has_many :comments
  has_many :subscribers, :class_name => "Subscriber", :foreign_key => "post_id"
  has_and_belongs_to_many :communities

  # after_create do
  #   Log.create({post: self, action: "created"})
  # end
  #
  # after_update do
  #   Log.create({post: self, action: "updated"})
  # end


  def as_json(options={})
    super(:only => [
        :id,
        :title,
        :description,
        :start_date,
        :end_date
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
        :communities => {
          :only => [
            :id,
            :name,
            :description,
            :home_page,
            :color
          ]
        },
        :user => {
            :only => [
                :email,
                :first_name,
                :last_name,
                :username
            ]
        }
      }
    )
  end


  def create_location(params)
    loc = Location.new.set_location_attrs(Location.new, params)
    self.locations << loc
  end
end
