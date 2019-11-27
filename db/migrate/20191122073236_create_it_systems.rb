class CreateItSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :it_systems do |t|
      t.string :name

      t.timestamps
    end
  end
end
