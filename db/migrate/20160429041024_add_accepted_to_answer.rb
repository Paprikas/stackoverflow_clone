class AddAcceptedToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :accepted, :boolean, default: false, null: false
  end
end
