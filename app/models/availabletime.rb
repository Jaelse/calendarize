class Availabletime < ApplicationRecord
  belongs_to :activity
  belongs_to :member
  belongs_to :user
  belongs_to :schedule
end
