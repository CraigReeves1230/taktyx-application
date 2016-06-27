class AddLocationableFieldToLocation < ActiveRecord::Migration
  def up
    add_reference :locations, :locationable, polymorphic: true, index: true
    remove_foreign_key :addresses, :location
    remove_reference :addresses, :location
  end

  def down
    remove_reference :locations, :locationable, polymorphic: true
    add_reference :addresses, :location, foreign_key: true
  end
end
