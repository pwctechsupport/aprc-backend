module Types
	class Types::ObjectType < Types::BaseUnion
		description "Types of an Object"

		possible_types Types::PolicyType, Types::BusinessProcessType, Types::ControlType, Types::RiskType, Types::UserType, Types::PolicyCategoryType, Types::ResourceType, Types::DepartmentType
		
		def self.resolve_type(object,context, **args)
			version_or_draft = PaperTrail::Version.find_by(object: object.to_json) || Draftsman::Draft.find_by(object: object.to_json)
			if version_or_draft&.item_type == "Policy"
				Types::PolicyType
			elsif version_or_draft&.item_type == "BusinessProcess"
				Types::BusinessProcessType
			elsif version_or_draft&.item_type == "Control"
				Types::ControlType
			elsif version_or_draft&.item_type == "Risk"
				Types::RiskType
			elsif version_or_draft&.item_type == "User"
				Types::UserType
			elsif version_or_draft&.item_type == "PolicyCategory"
				Types::PolicyCategoryType
			elsif version_or_draft&.item_type == "Resource"
				Types::ResourceType
			elsif version_or_draft&.item_type == "Department"
				Types::DepartmentType
			end
		end
		
	end
end