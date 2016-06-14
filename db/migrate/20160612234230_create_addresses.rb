class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line_1
      t.string :line_2, null: true
      t.string :city
      t.string :state
      t.string :zip_code
      t.timestamps null: false
    end
  end
end
