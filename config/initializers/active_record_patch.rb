module ActiveRecord
  # = Active Record Has Many Through Association
  module Associations
    class HasManyThroughAssociation < HasManyAssociation #:nodoc:
			alias_method :ori_delete_records, :delete_records
      def delete_records(records, method)
        method ||= :destroy
        ori_delete_records(records, method)
      end
    end
  end
end