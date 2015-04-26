module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def create_api_community(user_id)
    post '/api/communities', format: :json, :community => {
                               :name => 'Boone Community Network',
                               :description => 'Great job JSON API!',
                               :home_page => 'http://thehoick.com',
                               :color => '#ececec',
                               created_by: user_id
                           }
  end
end
