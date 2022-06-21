class CreateBookmarkRisks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmark_risks do |t|
      t.references :user, foreign_key: true
      t.references :risk, foreign_key: true

      t.timestamps
    end
  end
end
