class AddControlToActivityControls < ActiveRecord::Migration[5.2]
  def change
    add_reference :activity_controls, :control, foreign_key: true
  end
end
