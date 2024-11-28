class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :balance

  def balance
    object.amount
  end
end
