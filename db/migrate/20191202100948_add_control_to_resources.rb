class AddControlToResources < ActiveRecord::Migration[5.2]
  def change
    add_reference :resources, :control, foreign_key: true
  end
end
