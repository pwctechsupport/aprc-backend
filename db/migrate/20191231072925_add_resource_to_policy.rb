class AddResourceToPolicy < ActiveRecord::Migration[5.2]
  def change
    add_reference :policies, :resource, foreign_key: true
  end
end
