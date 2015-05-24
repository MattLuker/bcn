class Reply < ActiveRecord::Base
  acts_as_paranoid
  dragonfly_accessor :photo

  validates :content, presence: true

  belongs_to :comment
  belongs_to :user
end
