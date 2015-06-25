class User < ActiveRecord::Base
  # Remember to create a migration!
  validates :email, presence: true
  validates :fullname, presence: true
  validates :password, presence: true
end
