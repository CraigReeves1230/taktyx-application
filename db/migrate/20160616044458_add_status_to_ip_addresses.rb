class AddStatusToIpAddresses < ActiveRecord::Migration
  def change
    add_column :ip_addresses, :status, :string
  end
end
