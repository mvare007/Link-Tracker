class Client < ApplicationRecord
  # Associations
  has_many :tracking_links, dependent: :destroy

  # Validations
  validates :name, :store_url, presence: true, length: { maximum: 255 }
  validates :store_url, uniqueness: true

  # Callbacks
  before_validation :sanitize_store_url

  private

  def sanitize_store_url
    return if store_url.blank?

    uri = URI.parse(store_url)
    uri.scheme = 'https' if uri.scheme.nil?
    uri.to_s if %w[http https].include?(uri.scheme)
  end
end
