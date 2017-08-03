require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  has_many :group_members
  has_many :groups, through: :group_members
  # has_many :created_groups, through: :groups, foreign_key: :creator_id

  validates_presence_of :username, :email, :password
  validates_uniqueness_of :username, :email
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(plain_text_password, email_input)
    user_logging_in = User.find_by(email: email_input)
    BCrypt::Password.new(user_logging_in.password_hash) == plain_text_password && self.email == email_input
  end

end
