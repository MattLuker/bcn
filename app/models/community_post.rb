class CommunityPost < ActiveRecord::Base
  belongs_to :post
  belongs_to :community

  before_save :inc_counter
  before_update :dec_counter

  def inc_counter
    puts "community_id: #{community_id}"

    community = Community.find(community_id)
    community.posts_count += 1
    community.save
  end

  def dec_counter
    puts "community_id: #{community_id}"
    community = Community.find(community_id)
    community.posts_count -= 1
    community.save
  end
end