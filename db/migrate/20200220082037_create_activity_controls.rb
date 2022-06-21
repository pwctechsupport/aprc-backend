class CreateActivityControls < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_controls do |t|
      t.text :activity
      t.text :guidance

      t.timestamps
    end
  end
end
