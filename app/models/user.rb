class User < ApplicationRecord
  belongs_to :role
  has_many :documents, dependent: :destroy
  before_save { self.email = email.downcase }

  validates :email, uniqueness: true

  has_secure_password
  validates_presence_of :name, :email, :password, :password_digest
end
