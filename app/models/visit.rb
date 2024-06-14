class Visit < ApplicationRecord
  # Associations
  belongs_to :tracking_link, counter_cache: :visits_count

  # Validations
  validates :ip_address, presence: true
end
