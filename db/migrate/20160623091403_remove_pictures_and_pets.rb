class RemovePicturesAndPets < ActiveRecord::Migration
  def change
    drop_table :pets
    drop_table :pictures
  end
end
