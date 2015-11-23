class FacebookFindGroupJob < ActiveJob::Base
  queue_as :default
  include Sidekiq::Worker

  def perform(token, user, organization)

    @graph = Koala::Facebook::API.new(token)
    groups = @graph.get_connections("search?q='#{organization.name}'&type=group&limit=10", '')

    groups.each do |g|
      if organization.name.length == g['name'].length && organization.name == g['name']
        puts "name: #{g['name']}"
        puts "id: #{g['id']}"
        organization.facebook_group = g['id']
        organization.save
      end
    end

  end
end
