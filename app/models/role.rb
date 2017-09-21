class Role < ApplicationRecord
  has_many :users, dependent: :destroy

  validates_presence_of :role, :description
end
