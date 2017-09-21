class User < ApplicationRecord
  belongs_to :role
  has_many :documents, dependent: :destroy

  has_secure_password
  validates_presence_of :name, :email
end
