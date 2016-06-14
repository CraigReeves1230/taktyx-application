class CreateRelUserServices < ActiveRecord::Migration
  def change
    create_table :rel_user_services do |t|
      t.integer :sort_order, default: 0
      t.timestamps null: false
    end

    # Add references
    add_reference :rel_user_services, :user, index: true
    add_reference :rel_user_services, :service, index: true
  end
end
