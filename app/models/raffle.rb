class Raffle < ApplicationRecord
  belongs_to :pr_owner, class_name: 'User'
  belongs_to :first_raffle, class_name: 'User'
  belongs_to :second_raffle, class_name: 'User'
end
