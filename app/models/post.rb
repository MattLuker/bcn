class Post < ActiveRecord::Base
  acts_as_paranoid
  validates :title, presence: true
  validates :description, presence: true

  has_many :locations
  has_and_belongs_to_many :communities
  belongs_to :user

  after_create do
    Log.create({post: self, action: "created"})
  end

  after_update do
    Log.create({post: self, action: "updated"})
  end


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
