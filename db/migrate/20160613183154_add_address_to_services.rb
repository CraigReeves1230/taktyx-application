class AddAddressToServices < ActiveRecord::Migration
  def change
    add_reference :services, :address, foreign_key: true, index: true
  end
end
