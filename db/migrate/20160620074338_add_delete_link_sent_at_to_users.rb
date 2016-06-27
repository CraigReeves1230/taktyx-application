class AddDeleteLinkSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delete_sent_at, :datetime
  end
end
