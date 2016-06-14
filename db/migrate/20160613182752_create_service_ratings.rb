class CreateServiceRatings < ActiveRecord::Migration
  def change
    create_table :service_ratings do |t|
      t.float :score, default: 0
      t.text :comment, null: true
      t.timestamps null: false
    end

    # Add references
    add_reference :service_ratings, :user, foreign_key: true, index: true
    add_reference :service_ratings, :service, foreign_key: true, index: true

    # Add indexes
    add_index :service_ratings, [:user_id, :service_id]
  end
end
