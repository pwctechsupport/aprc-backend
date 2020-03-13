module Types
	class Types::OriginatorType < Types::BaseUnion
		description "Types of an Originator"

		possible_types Types::PolicyType, Types::BusinessProcessType, Types::ControlType, Types::RiskType, Types::UserType, Types::PolicyCategoryType, Types::ResourceType
		
		def self.resolve_type(object,context)
			if object.is_a?(Policy)
				Types::PolicyType
			elsif object.is_a?(BusinessProcess)
				Types::BusinessProcessType
			elsif object.is_a?(Control)
				Types::ControlType
			elsif object.is_a?(Risk)
				Types::RiskType
			elsif object.is_a?(User)
				Types::UserType
			elsif object.is_a?(PolicyCategory)
				Types::PolicyCategoryType
			elsif object.is_a?(Resource)
				Types::ResourceType
			end
		end
		
	end
end