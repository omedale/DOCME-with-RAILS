class Document < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :content, :access, :owner
end
