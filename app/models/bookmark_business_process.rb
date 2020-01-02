class BookmarkBusinessProcess < ApplicationRecord
  belongs_to :user
  belongs_to :business_process
end
