module Types
	class Types::ItemType < Types::BaseUnion
		description "Types of an Items"

		possible_types Types::PolicyRiskType, Types::PolicyType, Types::BookmarkBusinessProcessType, Types::BookmarkControlType, Types::BookmarkPolicyType, Types::BookmarkRiskType, Types::BusinessProcessType, Types::ControlType, Types::PolicyCategoryType, Types::ReferenceType, Types::ResourceRatingType, Types::ResourceType, Types::RiskType, Types::UserType
		
		def self.resolve_type(object,context)
			if object.is_a?(Policy)
				Types::PolicyType
			elsif object.is_a?(BookmarkBusinessProcess)
				Types::BookmarkBusinessProcessType
			elsif object.is_a?(BookmarkControl)
				Types::BookmarkControlType
			elsif object.is_a?(BookmarkRisk)
				Types::BookmarkRiskType
			elsif object.is_a?(BookmarkPolicy)
				Types::BookmarkPolicyType
			elsif object.is_a?(BusinessProcess)
				Types::BusinessProcessType
			elsif object.is_a?(Control)
				Types::ControlType
			elsif object.is_a?(PolicyCategory)
				Types::PolicyCategoryType
			elsif object.is_a?(PolicyRisk)
				Types::PolicyRiskType
			elsif object.is_a?(Reference)
				Types::ReferenceType
			elsif object.is_a?(ResourceRating)
				Types::ResourceRatingType
			elsif object.is_a?(Resource)
				Types::ResourceType
			elsif object.is_a?(Risk)
				Types::RiskType
			elsif object.is_a?(User)
				Types::UserType
			end
		end
		
	end
end