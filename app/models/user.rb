class User < ApplicationRecord
  include InvalidatesCache
  belongs_to :role
  has_many :documents, dependent: :destroy
  before_save { self.email = email.downcase }

  validates :email, uniqueness: true

  has_secure_password
  validates_presence_of :name, :email, :password

  def self.search(search)
    where("name LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%")
  end
end
