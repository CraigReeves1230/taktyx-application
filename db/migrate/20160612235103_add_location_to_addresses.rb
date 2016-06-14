class AddLocationToAddresses < ActiveRecord::Migration
  def change
    add_reference :addresses, :location, foreign_key: true, index: true
  end
end
