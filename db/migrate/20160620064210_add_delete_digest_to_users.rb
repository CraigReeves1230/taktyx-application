class AddDeleteDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delete_digest, :string
  end
end
