class AddIsActiveToServices < ActiveRecord::Migration
  def change
    add_column :services, :is_active, :boolean, default: false
    add_index :services, [:is_active]
  end
end
