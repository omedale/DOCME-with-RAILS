class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :owner, :user_id, :access, :created_at
end
