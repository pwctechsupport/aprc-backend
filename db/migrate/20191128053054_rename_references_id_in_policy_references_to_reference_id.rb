class RenameReferencesIdInPolicyReferencesToReferenceId < ActiveRecord::Migration[5.2]
  def change
    rename_column :policy_references, :references_id, :reference_id
  end
end
