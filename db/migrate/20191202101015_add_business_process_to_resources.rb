class AddBusinessProcessToResources < ActiveRecord::Migration[5.2]
  def change
    add_reference :resources, :business_process, foreign_key: true
  end
end
