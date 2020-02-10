module Types
	class Types::ObjectType < Types::BaseUnion
		description "Types of an Object"

		possible_types Types::PolicyType, Types::BusinessProcessType, Types::ControlType, Types::RiskType, Types::UserType
		
		def self.resolve_type(object,context)
			if object&.keys == Policy.column_names
				Types::PolicyType
			elsif object&.keys == BusinessProcess.column_names
				Types::BusinessProcessType
			elsif object&.keys == Control.column_names
				Types::ControlType
			elsif object&.keys == Risk.column_names
				Types::RiskType
			elsif object&.keys == User.column_names
				Types::UserType
			else
				Types::BaseScalar
			end
		end
		
	end
end