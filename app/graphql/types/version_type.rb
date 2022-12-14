module Types
    class Types::VersionType < Types::BaseObject
        description "Version of an Object"

        field :id, ID, null: true
        field :item_type, String, null: true
        field :item_id, ID, null: true
        field :event, String, null: true
        field :object_result, Types::ObjectType, null: true
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :object_changes, String, null: true
        field :item, Types::ItemType, null: true
        field :user, Types::UserType, null: true
        field :description, String, null: true
        def user
            who = object.whodunnit.to_i
            if who === 0 || who === nil
            else
                User.find(who)
            end
        end

        def object_result
            return nil unless object.object.present?
            begin
                JSON.parse(object.object)
            rescue
                return nil
            end
        end

        def description
            if object.whodunnit
                user = User.find(object.whodunnit)
            end
            
            event_name = if object.event == "create" then "created" elsif object.event == "update" then "updated" elsif object.event == "destroy" then "destroyed" else object.event end
            
            previous_status, current_status = JSON.parse(object&.object_changes)&.try(:[], "status")
            
            if object.event == "destroy"
                if object.item_type == "Control"
                    "#{user&.name || "someone"} #{event_name} #{object.item_type}: #{JSON.parse(object.object)["description"]}"
                elsif object.item_type == "Policy"
                    "#{user&.name || "someone"} #{event_name} #{object.item_type}: #{JSON.parse(object.object)["title"]}"
                else
                    "#{user&.name || "someone"} #{event_name} #{object.item_type}: #{JSON.parse(object.object)["name"] || "something"}"
                end
            elsif object.item_type == "Import"
                "#{user&.name || "someone"} imported #{object.item&.to_humanize}"
            else
                if previous_status.present?
                  "#{user&.name || "someone"} #{event_name} #{object.item_type}: #{object.item&.to_humanize} from #{previous_status&.humanize} to #{current_status&.humanize}"
                else
                  "#{user&.name || "someone"} #{event_name} #{object.item_type}: #{object.item&.to_humanize}"
                end
            end
        end
    end
end

