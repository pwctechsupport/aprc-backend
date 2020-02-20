class CreateFileAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :file_attachments do |t|
      t.integer :user_id
      t.string :originator_type
      t.integer :originator_id

      t.timestamps
    end
  end
end
