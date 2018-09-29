class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role_id
end
