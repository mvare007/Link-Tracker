class LinksController < ApplicationController
  before_action :set_tracking_link, only: %i[redirect]

  # @route GET /:tracking_code
  def redirect
    visit = Visit.new(tracking_link: @tracking_link, ip_address: request.remote_ip, user_agent: request.user_agent)

    if visit.save
      redirect_to sanitized_url(@tracking_link.client_store_url), allow_other_host: true
      # render json { redirect_to: @tracking_link.client_store_url }, status: :ok
    else
      Rails.logger.error "Failed to save visit due to the following errors:\nErrors: #{visit.errors.full_messages.join("\n")}"
      render json: { errors: 'Invalid tracking code' }, status: :unprocessable_entity
    end
  end

  private

  def set_tracking_link
    @tracking_link = TrackingLink.find_by(tracking_code: params[:tracking_code])
    @tracking_link.present? or return render json: { errors: 'Tracking Link not found' }, status: :unprocessable_entity
  end

  def sanitized_url(url)
    uri = URI.parse(url)
    uri.scheme = 'https' if uri.scheme.nil?
    uri.to_s if %w[http https].include?(uri.scheme)
  end
end
