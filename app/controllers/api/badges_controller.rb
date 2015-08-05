class Api::BadgesController < Api::ApiController
  before_filter :authenticate, only: [:index, :show]

  def index
    badges = Badge.all
    render status: 200, json: badges.as_json
  end

  def show
    begin
      badge = Badge.find(params[:id])
      render status: 200, json: badge.as_json()
    rescue
      render status: 404, json: {
                            errors: 'Badge not found.'
                        }.to_json
    end
  end
end