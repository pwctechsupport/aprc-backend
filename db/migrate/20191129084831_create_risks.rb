class CreateRisks < ActiveRecord::Migration[5.2]
  def change
    create_table :risks do |t|
      t.text :name

      t.timestamps
    end
  end
end
