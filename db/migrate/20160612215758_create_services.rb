class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name, unique: true
      t.boolean :is_active, default: false
      t.timestamp :last_active
      t.string :status
      t.text :description, null: true
      t.timestamps null: false
    end

    # Add references
    add_reference :services, :category, foreign_key: true, index: true
  end
end
