class Subscriber < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :community
end