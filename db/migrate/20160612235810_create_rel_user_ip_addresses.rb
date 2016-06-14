class CreateRelUserIpAddresses < ActiveRecord::Migration
  def change
    create_table :rel_user_ip_addresses do |t|
      t.timestamps null: false
    end

    # Add references
    add_reference :rel_user_ip_addresses, :user, foreign_key: true, index: true
    add_reference :rel_user_ip_addresses, :ip_address, foreign_key: true, index: true
  end
end
