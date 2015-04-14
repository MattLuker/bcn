module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def create_api_community
    post '/api/communities', format: :json, :community => {
                               :name => 'Boone Community Network',
                               :description => 'Great job JSON API!',
                               :home_page => 'http://thehoick.com',
                               :color => '#ececec'
                           }
  end
end
