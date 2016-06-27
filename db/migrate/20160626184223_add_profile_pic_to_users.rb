class AddProfilePicToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_pic, :integer
  end
end
