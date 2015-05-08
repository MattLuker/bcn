class User < ActiveRecord::Base
  acts_as_paranoid
  has_secure_password

  validates :username, uniqueness: true
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

  before_validation :set_username
  before_save :downcase_email

  def self.koala(auth)
    access_token = auth['token']
    facebook = Koala::Facebook::API.new(access_token)
    facebook.get_object("me?fields=id,name,picture,first_name,last_name,link,events")
    #facebook.get_object('me')
  end

  def downcase_email
    self.email = email.downcase unless email.nil?
  end

  def set_username
    self.username = email if username.blank?
  end

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64)
  end

  def as_json(options={})
    super(:except => [:password_digest])
  end
end