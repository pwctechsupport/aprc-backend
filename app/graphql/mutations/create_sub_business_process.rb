module Mutations
  class CreateSubBusinessProcess < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :parent_id, ID, required: true


    # return type from the mutation
    field :business_process, Types::BusinessProcessType, null: true

    def resolve(parent_id:, name: nil)
      business_process = BusinessProcess.create!(
        name: name,
        parent: BusinessProcess.find(parent_id)
      )
      {business_process: business_process}
    end
  end
end