class DropDescriptionTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :descriptions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
