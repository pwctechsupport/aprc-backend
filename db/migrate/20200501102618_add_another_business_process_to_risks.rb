class AddAnotherBusinessProcessToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :business_process, :text
  end
end
