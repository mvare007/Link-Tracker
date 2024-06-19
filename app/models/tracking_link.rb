class TrackingLink < ApplicationRecord
  # Associations
  belongs_to :client
  has_many :visits, dependent: :destroy

  # Validations
  validates :tracking_code, presence: true, length: { maximum: 255 }, uniqueness: true

  # Delegates
  delegate :store_url, to: :client, prefix: true

  # Callbacks
  before_validation :generate_tracking_code, on: :create

  # Scopes
  scope :for_client, ->(client) { where(client:) }

  private

  def generate_tracking_code
    self.tracking_code ||= TrackingCodeGenerator.call
  end
end
