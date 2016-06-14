class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, unique: true
      t.text :description, null: true
      t.timestamps null: false
    end

    # Create references
    add_reference :categories, :category, index: true

  end
end
