class CreateImports < ActiveRecord::Migration[5.2]
  def change
    create_table :imports do |t|
      t.string :model_name
      t.attachment :file

      t.timestamps
    end
  end
end
