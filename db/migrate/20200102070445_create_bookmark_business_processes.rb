class CreateBookmarkBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmark_business_processes do |t|
      t.references :user, foreign_key: true
      t.references :business_process, foreign_key: true

      t.timestamps
    end
  end
end
