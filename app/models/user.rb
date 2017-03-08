class User < ActiveRecord::Base
  self.table_name = 'users'

  has_many :comments, foreign_key: 'user_id'
  has_many :posts, foreign_key: 'user_id', dependent: :destroy
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: 'followed_id',
           class_name:  'Relationship',
           dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email_address, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 8 }
  has_secure_password

  before_save { self.email_address = email_address.downcase }
  before_create :create_remember_token

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Post.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def gravatar_for(options = { size: 80} )
    gravatar_id = Digest::MD5::hexdigest(self.email_address.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    ActionController::Base.helpers.image_tag(gravatar_url, alt: self.name, class: "gravatar-mention").html_safe
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
