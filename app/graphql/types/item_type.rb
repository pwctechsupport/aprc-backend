class Types::ItemType < Types::BaseUnion
	description "Types of an Items"

	possible_types Types::PolicyType, bookmark
									

	def self.resolve_type(object,context)
		if object.is_a?(Policy)
			Types::PolicyType
		end
	end
end