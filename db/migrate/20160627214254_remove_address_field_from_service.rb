class RemoveAddressFieldFromService < ActiveRecord::Migration
  def change
    remove_foreign_key :services, :addresses
    remove_reference :services, :address
  end
end
