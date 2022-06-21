class CreateBookmarkPolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmark_policies do |t|
      t.references :user, foreign_key: true
      t.references :policy, foreign_key: true

      t.timestamps
    end
  end
end
