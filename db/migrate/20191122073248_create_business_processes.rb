class CreateBusinessProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :business_processes do |t|
      t.string :name

      t.timestamps
    end
  end
end
