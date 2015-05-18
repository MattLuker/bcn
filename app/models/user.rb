class User < ActiveRecord::Base
  acts_as_paranoid
  has_secure_password

  validates :username, allow_nil: true, uniqueness: true
  validates :email, allow_nil: true, uniqueness: true,
   format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9\.-]+\.[A-Za-z]+\Z/ }

  after_create do
    Log.create({user: self, action: "created"})
  end

  after_update do
    Log.create({user: self, action: "updated"})
  end

  has_many :posts
  has_and_belongs_to_many :communities

  before_save :downcase_email
  #before_validation :set_username

  def self.facebook(auth)
    @facebook = Koala::Facebook::API.new(auth['token'])
  end

  def downcase_email
    self.email = email.downcase unless email.nil?
  end

  def set_username
    username = email.split('@')[0] unless email.nil?
    if User.find_by(username: username)
      self.username = username + '_' + (0...5).map { ('a'..'z').to_a[rand(26)] }.join unless email.nil?
    else
      self.username = username unless email.nil?
    end
  end

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64)
  end

  def generate_user_merge_token!
    update_attribute(:merge_token, SecureRandom.urlsafe_base64)
  end

  def as_json(options={})
    super(:except => [:password_digest])
  end
end