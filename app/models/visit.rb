class Visit < ApplicationRecord
  # Associations
  belongs_to :tracking_link

  # Validations
  validates :ip_address, :user_agent, presence: true
end
