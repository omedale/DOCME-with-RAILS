class Document < ApplicationRecord
  include InvalidatesCache
  belongs_to :user

  validates_presence_of :title, :content, :access

  def self.search(search, user_id, user_role)
    if user_role[:role] == 'admin'
      where("(title LIKE ? OR content LIKE ?)", "%#{search}%", "%#{search}%")
    else
      where("((title LIKE ? OR content LIKE ?)) AND ((user_id = ?) OR (access = ? OR access = ?))", "%#{search}%", "%#{search}%", user_id, 'public', user_role[:role])
    end
  end
end