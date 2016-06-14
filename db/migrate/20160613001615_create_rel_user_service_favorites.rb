class CreateRelUserServiceFavorites < ActiveRecord::Migration
  def change
    create_table :rel_user_service_favorites do |t|
      t.integer :sort_order, default: 0
      t.timestamps null: false
    end

    # Add references
    add_reference :rel_user_service_favorites, :user
    add_reference :rel_user_service_favorites, :service
  end
end
