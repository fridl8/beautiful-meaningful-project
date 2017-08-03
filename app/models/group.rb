class Group < ActiveRecord::Base
  belongs_to :creator, class_name: :User
  has_many :group_members
  has_many :members, through: :group_members, source: :user

  validates_presence_of :name
  validates_uniqueness_of :name

end
