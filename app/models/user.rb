class User < ApplicationRecord
	has_many :raffle, class_name: 'Raffle'
end
