class Client < ApplicationRecord
	# Associations
	has_many :tracking_links, dependent: :destroy

	# Validations
	validates :name, :store_url, presence: true, length: { maximum: 255 }
	validates :store_url, uniqueness: true
end
