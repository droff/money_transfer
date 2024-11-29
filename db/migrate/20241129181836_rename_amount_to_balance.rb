class RenameAmountToBalance < ActiveRecord::Migration[8.0]
  def change
    rename_column :accounts, :amount, :balance
  end
end
