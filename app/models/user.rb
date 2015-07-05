class User < ActiveRecord::Base
  acts_as_paranoid
  has_secure_password
  dragonfly_accessor :photo

  attr_accessor :photo_web_url

  validates :username, allow_nil: true, uniqueness: true
  validates :email, allow_nil: true, uniqueness: true,
   format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9\.-]+\.[A-Za-z]+\Z/ }
  validates :web_link, allow_nil: true, format: { with: /(https?|ftp|file|ssh):\/\// }

  # TODO: Figure out how to validate, or skip validation, for gravatar URL images.
  #validates_property :ext, of: :photo, in: ['jpeg', 'jpg', 'png', 'gif', 'svg', 'svgz', 'JPG'], if: :photo_changed?
  validates_property :mime_type, of: :photo,
                     in: ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/svg', 'application/octet-stream'],
                     if: :photo_changed?
  validates_property :format, of: :photo, in: ['jpeg', 'png', 'gif', 'svg', 'svgz'], if: :photo_changed?

  has_many :posts
  has_many :comments
  has_many :subscriptions, :class_name => "Subscriber", :foreign_key => "user_id"
  has_many :facebook_subscriptions
  has_and_belongs_to_many :communities, before_add: :inc_users_count, before_remove: :dec_users_count

  before_save :downcase_email
  before_validation :set_photo
  before_destroy :dec_all_users_count

  def self.facebook(auth)
    @facebook = Koala::Facebook::API.new(auth['token'])
  end

  def self.twitter(auth_hash)

    user = User.find_by(twitter_id: auth_hash.uid)
    unless user.nil?
      user = User.find_by(username: auth_hash.info.nickname)
    else
      user = create(username: auth_hash.info.nickname, password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join)
    end

    name = auth_hash.info.name.split(' ') unless auth_hash.info.name.nil?
    if user.photo.nil?
      user.photo_url = auth_hash.info.image unless auth_hash.info.image.nil?
    end
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

    if user.photo.nil?
      user.photo_url = auth_hash.info.image unless auth_hash.info.image.nil?
    end
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
    self.email = email.strip.downcase unless email.nil?
  end

  def set_photo
    unless self.email.nil?
      if self.photo.nil?
        hash = Digest::MD5.hexdigest(downcase_email)
        self.photo_url = "http://gravatar.com/avatar/#{hash}?s=150"

        # Not sure why I have to save here, but it doesn't keep the photo info if I don't.
        self.save
      end
    end
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

  def admin?
    true if role == 'admin'
  end

  def explicit?
    true if explicit
  end

  def as_json(options={})
    self.photo_web_url = self.photo.url if self.photo
    super(methods: :photo_web_url, :only => [
        :id,
        :first_name,
        :last_name,
        :email,
        :created_at,
        :username,
        :facebook_id,
        :facebook_link,
        :twitter_id,
        :twitter_link,
        :google_id,
        :google_link,
        :web_link,
        :photo_name,
        :photo_web_url,
        :role
    ])
  end

  private
  def inc_users_count(model)
    Community.increment_counter('users_count', model.id)
  end

  def dec_users_count(model)
    Community.decrement_counter('users_count', model.id)
  end

  def dec_all_users_count
    self.communities.each do |community|
      Community.decrement_counter('users_count', community.id)
    end
  end
end
