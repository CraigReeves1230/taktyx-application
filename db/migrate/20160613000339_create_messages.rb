class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content, null: true
      t.integer :sender_id, index: true
      t.integer :recipient_id, index: true
      t.boolean :is_read, default: false
      t.timestamps null: false
    end
  end
end
