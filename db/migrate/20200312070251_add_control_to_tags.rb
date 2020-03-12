class AddControlToTags < ActiveRecord::Migration[5.2]
  def change
    add_reference :tags, :control, foreign_key: true
  end
end
