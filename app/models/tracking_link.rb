class TrackingLink < ApplicationRecord
  # Associations
  belongs_to :client
  has_many :visits, dependent: :destroy, counter_cache: true

	# Validations
  validates :tracking_code, :target_url, presence: true, length: { maximum: 255 }
  validates :tracking_code, uniqueness: { scope: :client_id }

  # Callbacks
  before_validation :generate_tracking_code, on: :create

  # Scopes
  scope :for_client, ->(client) { where(client: client) }

  private

  def generate_tracking_code
    self.tracking_code ||= SecureRandom.hex(5)
  end
end
