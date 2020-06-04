class CreateRequestEdits < ActiveRecord::Migration[5.2]
  def change
    create_table :request_edits do |t|
      t.string :originator_type
      t.integer :originator_id
      t.string :state
      t.integer :user_id
      t.integer :approver_id

      t.timestamps
    end
  end
end
