class Log < ActiveRecord::Base
  belongs_to :post
  belongs_to :location
  belongs_to :community
end
