class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :body
      t.string :originator_type
      t.integer :originator_id
      t.boolean :is_read, :default => false
      t.text :data

      t.timestamps
    end
  end
end
