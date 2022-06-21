class CreateBookmarkControls < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmark_controls do |t|
      t.references :user, foreign_key: true
      t.references :control, foreign_key: true

      t.timestamps
    end
  end
end
