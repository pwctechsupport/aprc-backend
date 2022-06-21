class CreateEnumLists < ActiveRecord::Migration[5.2]
  def change
    create_table :enum_lists do |t|
      t.string :name
      t.string :code
      t.string :category_type

      t.timestamps
    end
  end
end
