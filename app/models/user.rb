class User < ApplicationRecord
	has_many :urls
	has_many :categories, through: :urls
	validates :name, presence: true, length: {minimum: 3}
end
