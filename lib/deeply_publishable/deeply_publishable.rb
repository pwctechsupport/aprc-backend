# frozen_string_literal: true
# To use this, define on any model that already has `has_drafts`
# ```
# class Blog < ApplicationRecord
#   include DeeplyPublishable
#
#   has_drafts
#   associations_to_publish :posts, :pages
#   ...
# end
# ```
#
# With the above definition, there are two publicly available
# instance methods provided:
# - deep_publish!
# - deep_discard!
# - deep_save_draft!
# - deep_trash!
#
# Both of these will traverse the associations as defined by
# associations_to_publish, either publishing or discarding drafts
# for any draft object encountered.
#
# NOTE: The draft becomes the real version when published.
#       Until publish, the data for the actual model in the model's table
#       is the same as it was before the draft was created.
module DeeplyPublishable
  extend ActiveSupport::Concern

  included do
    # Array of Symbols, representing association names
    cattr_accessor :publishable_associations

    class << self
      # can be called multiple times.
      # each call appends to publishable_associations
      def associations_to_publish(*association_list)
        self.publishable_associations ||= []
        self.publishable_associations.concat(Array[*association_list])
        self.publishable_associations.uniq!
      end
    end
  end

  def deep_publish!
    ActiveRecord::Base.transaction { _dangerous_deep_publish }
  end

  def deep_discard!
    ActiveRecord::Base.transaction { _dangerous_deep_discard }
  end

  def deep_save_draft!
    ActiveRecord::Base.transaction { _dangerous_deep_save }
  end

  def deep_trash!
    ActiveRecord::Base.transaction { _dangerous_deep_trash }
  end

  # Use instead of destroy
  def _dangerous_deep_trash
    draft_destruction
    _invoke_on_publishable_associations(:_dangerous_deep_trash)
  end

  # Use instead of save/update
  def _dangerous_deep_save
    # _destroy will be true when using accepts_nested_attributes_for
    # and a nested model has been selected for deletion while
    # updating a parent model
    _destroy ? draft_destruction : save_draft

    _invoke_on_publishable_associations(:_dangerous_deep_save)
  end

  def _dangerous_deep_publish
    draft&.publish!
    _invoke_on_publishable_associations(:_dangerous_deep_publish)
  end

  def _dangerous_deep_discard
    draft&.revert!
    _invoke_on_publishable_associations(:_dangerous_deep_discard)
  end

  def _invoke_on_publishable_associations(method)
    return unless publishable_associations.present?

    publishable_associations.map do |association|
      # superclasses may not respond_to, but subclasses might
      next unless respond_to?(association)

      relation = send(association)
      _invoke_on_relation(relation, method)
    end.flatten
  end

  # A relation may be the result of a has_many
  # or a belongs_to relationship.
  #
  # @param [Symbol] method
  def _invoke_on_relation(relation, method)
    # has_many / collection of records
    return relation.each(&method) if relation.respond_to?(:each)

    # belongs_to / singular record
    relation.send(method)
  end
end