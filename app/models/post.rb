class Post < ActiveRecord::Base
  self.table_name = 'posts'

  belongs_to :user
  validates :content, presence: true, length: { minimum: 3, maximum: 220 }
  validates :user_id, presence: true, numericality: { only_integer: true, message: 'must be provided' }

  default_scope -> { order('created_at DESC') }
  after_create :add_mentions

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def add_mentions
    Mention.create_from_text(self)
  end

end
