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

  def self.twitter(auth_hash)

    user = User.find_by(twitter_id: auth_hash.uid)
    if user.nil?
      user = create(username: auth_hash.info.nickname, password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join)
    end

    name = auth_hash.info.name.split(' ') unless auth_hash.info.name.nil?
    user.photo = auth_hash.info.image unless auth_hash.info.image.nil?
    user.first_name = name[0] unless name[0].nil?
    user.last_name = name[-1] unless name[-1].nil?

    user.twitter_id = auth_hash.uid
    user.twitter_token = auth_hash.credentials.token
    user.twitter_secret = auth_hash.credentials.secret
    user.twitter_link = auth_hash.info.urls.Twitter

    user.save
    user
  end

  def self.google(auth_hash)
    user = User.find_by(email: auth_hash.info.email)
    if user.nil?
      user = create(email: auth_hash.info.email, password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join)
    end

    user.photo = auth_hash.info.image unless auth_hash.info.image.nil?
    user.first_name = auth_hash.info.first_name unless auth_hash.info.first_name.nil?
    user.last_name = auth_hash.info.last_name unless auth_hash.info.last_name.nil?
    user.email = auth_hash.info.email

    user.google_id = auth_hash.uid
    user.google_token = auth_hash.credentials.token
    user.google_link = auth_hash.extra.raw_info.profile

    user.save
    user
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