class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :balance

  def balance
    object.balance.to_f
  end
end
