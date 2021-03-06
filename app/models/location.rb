class Location < ActiveRecord::Base
  require 'nominatim'

  acts_as_paranoid
  has_and_belongs_to_many :posts
  belongs_to :community
  belongs_to :organization

  validates :lat, presence: true
  validates :lon, presence: true

  def self.lookup_name(params)
    Nominatim.configure do |config|
      config.email = Rails.application.config_for(:nominatim)['email']
      config.endpoint = Rails.application.config_for(:nominatim)['host']
    end

    if params[:name]
      places = Nominatim.search("#{params[:name]}").limit(10).address_details(true)
    else
      places = Nominatim.search("#{params[:lat]},#{params[:lon]}").limit(10).address_details(true)
    end
    if places.count != 0
      places.each do |place|
        return { name: place.display_name.split(',')[0], lat: place.lat, lon: place.lon }
      end
    else
      return { name: '', lat: 36.2114, lon: -81.6686 }
    end
  end

  def set_location_attrs(loc, params, update=false)

    Nominatim.configure do |config|
      config.email = Rails.application.config_for(:nominatim)['email']
      config.endpoint = Rails.application.config_for(:nominatim)['host']
    end

    places = Nominatim.search("#{params[:lat]},#{params[:lon]}").limit(10).address_details(true)
    for place in places

      loc.lat = params[:lat]
      loc.lon = params[:lon]

      if params[:post_id]
        loc.post_id = params[:post_id].to_i
      end

      loc.name = place.display_name.split(',')[0]
      if place.address.road and place.address.house_number
        loc.address = place.address.house_number + " " + place.address.road
      elsif place.address.house_number and not place.address.road
        loc.address = place.address.house_number
      elsif not place.address.house_number and place.address.road
        loc.address = place.address.road
      else
        loc.address = 'not found'
      end

      if place.address.city
        city = place.address.city
      elsif place.address.town
        city = place.address.town
      elsif place.address.village
        city = place.address.village
      end
      loc.city = city

      loc.state = place.address.state
      loc.postcode = place.address.postcode
      loc.county = place.address.county
      loc.country = place.address.country
    end

    if update
      return loc.save
    end

    return loc
  end

  def create(params)
    loc = self.set_location_attrs(Location.new, params)
    return loc
  end

  def update_attributes(loc_id, params)
    loc = self.set_location_attrs(Location.find(loc_id), params, update: true)
    return loc
  end

  def as_json(options={})

    super(:only => [
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
          ],
          :include => {
              # :posts => {
              #     :only => [
              #         :id,
              #         :title,
              #         :description,
              #         :start_date,
              #         :end_date,
              #         :created_at
              #     ]
              # },
              :community => {
                  :only => [
                      :id,
                      :name,
                      :description,
                      :home_page,
                      :color
                  ]
              },
              :organization => {
                  :only => [
                      :id,
                      :name,
                      :description,
                      :home_page,
                      :color
                  ]
              },
          }
    )
  end

end
