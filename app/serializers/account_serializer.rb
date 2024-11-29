class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :balance
end
