class LinksController < ApplicationController
  before_action :set_tracking_link, :create_visit, only: %i[redirect]

  # @route GET /:tracking_code
  def redirect
    redirect_to @tracking_link.client_store_url, allow_other_host: true
  end

  private

  def set_tracking_link
    @tracking_link = TrackingLink.find_by(tracking_code: params[:tracking_code])
    @tracking_link.present? or return render json: { errors: 'Tracking Link not found' }, status: :unprocessable_entity
  end

  def create_visit
    visit = Visit.new(tracking_link: @tracking_link, ip_address: request.remote_ip, user_agent: request.user_agent)
    return if visit.save

    log_visit_error(visit)
  end

  def log_visit_error(visit)
    Rails.logger.error "Failed to save visit due to the following errors:\nErrors: #{visit.errors.full_messages.join("\n")}"
  end
end
