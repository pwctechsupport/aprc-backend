module Mutations
  class CreateBusinessProcess < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :business_process, Types::BusinessProcessType, null: true

    def resolve(name: nil)
      business_process = BusinessProcess.create!(
        name: name
      )
      {business_process: business_process}
    end
  end
end