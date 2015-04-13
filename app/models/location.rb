class Location < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :post

  validates :lat, presence: true
  validates :lon, presence: true

  after_create do
    Log.create({location: self, action: 'created'})
  end

  after_update do
    Log.create({location: self, action: 'updated'})
  end

  def get_location_name(loc, params, update=false)
    require 'nominatim'

    Nominatim.configure do |config|
      puts Rails.application.config_for(:nominatim)['host']
      config.email = 'adam@thehoick.com'
      config.endpoint = Rails.application.config_for(:nominatim)['host']
    end

    # # Use static data if testing.
    # if Rails.env.test? and params[:lat] == 36.2168215386211
    #   loc.lat = params[:lat]
    #   loc.lon = params[:lon]
    #   loc.post_id = params[:post_id].to_i
    #   loc.name = 'Kenneth E. Peacock Hall'
    #   loc.address = '416 Howard Street'
    #   loc.city = 'Boone'
    #   loc.state = 'NC'
    #   loc.county = 'Watauga'
    #   loc.country = 'us'
    #   loc.save
    #   return loc
    # end

    places = Nominatim.search("#{params[:lat]},#{params[:lon]}").limit(10).address_details(true)
    for place in places

      loc.lat = params[:lat]
      loc.lon = params[:lon]
      loc.post_id = params[:post_id].to_i

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
    loc = self.get_location_name(Location.new, params)
    return loc
  end

  def update_attributes(loc_id, params)
    loc = self.get_location_name(Location.find(loc_id), params, update: true)
    return loc
  end
end
