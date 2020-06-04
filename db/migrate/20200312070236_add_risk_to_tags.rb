class AddRiskToTags < ActiveRecord::Migration[5.2]
  def change
    add_reference :tags, :risk, foreign_key: true
  end
end
