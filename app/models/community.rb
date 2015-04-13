class Community < ActiveRecord::Base
  acts_as_paranoid
  validates :name, presence: true, uniqueness: true

  after_create do
    Log.create({community: self, action: "created"})
  end

  after_update do
    Log.create({community: self, action: "updated"})
  end

  has_and_belongs_to_many :posts

  def as_json(options={})
    super(:only => [
            :id,
            :name,
            :description,
            :home_page,
            :color
      ],
      :include => {
        :posts => {
          :only => [
            :id,
            :title,
            :description,
          ],
          :include => {
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
          },
        },
      }
    )
  end
end
