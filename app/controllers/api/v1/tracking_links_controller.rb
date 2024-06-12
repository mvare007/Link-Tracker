module Api
  module V1
    class TrackingLinksController < ApplicationController
      before_action :set_tracking_link, only: %i[show redirect stats]
      before_action :set_client, only: %i[index create]

      # @route GET /api/v1/tracking_links (api_v1_tracking_links)
      def index
        @tracking_links = TrackingLink.for_client(@client)
                                      .paginate(page: params[:page], per_page: 20)
      end

      # @route GET /api/v1/tracking_links/:id (api_v1_tracking_link)
      def show
      end

      # @route POST /api/v1/tracking_links (api_v1_tracking_links)
      def create
        @tracking_link = TrackingLink.new(tracking_link_params)
        @tracking_link.client = @client
        if @tracking_link.save
          render :show, status: :created
        else
          render json: { errors: @tracking_link.errors }, status: :unprocessable_entity
        end
      end

      # @route GET /api/v1/tracking_links/:id/redirect (redirect_api_v1_tracking_link)
      def redirect
        visit = Visit.new(tracking_link: @tracking_link, ip_address: request.remote_ip, user_agent: request.user_agent)
        if visit.save
          redirect_to @tracking_link.target_url
        else
          Rails.logger.error "Failed to save visit due to the following errors:\nErrors: #{visit.errors.full_messages.join("\n")}"
          render json: { errors: 'Invalid request' }, status: :unprocessable_entity
        end
      end

      # @route GET /api/v1/tracking_links/:id/stats (stats_api_v1_tracking_link)
      def stats
        @visits = @tracking_link.visits
                                .paginate(page: params[:page], per_page: 20)
      end

      private

      def set_tracking_link
        @tracking_link = TrackingLink.find_by(tracking_code: params[:tracking_code])
        @tracking_link.present? or return render json: { errors: 'Tracking Link not found' },
                                                 status: :unprocessable_entity
      end

      def set_client
        @client = Client.find_by(store_url: params[:store_url])
        @client.present? or return render json: { errors: 'Client not found' }, status: :unprocessable_entity
      end

      def tracking_link_params
        params.require(:tracking_link).permit(:target_url)
      end
    end
  end
end