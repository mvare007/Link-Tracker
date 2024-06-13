module Api
  module V1
    class TrackingLinksController < ApplicationController
      before_action :set_tracking_link, only: %i[show tracking_data]
      before_action :set_client, only: %i[index create]

      # @route GET /api/v1/tracking_links (api_v1_tracking_links)
      def index
        @tracking_links = TrackingLink.for_client(@client)
                                      .paginate(page: params[:page], per_page: 20)
      end

      # @route GET /api/v1/tracking_links/:tracking_code (api_v1_tracking_link)
      def show
      end

      # @route POST /api/v1/tracking_links (api_v1_tracking_links)
      def create
        @tracking_link = TrackingLink.new(client: @client)
        if @tracking_link.save
          render :show, status: :created
        else
          render json: { errors: @tracking_link.errors }, status: :unprocessable_entity
        end
      end

      # @route GET /api/v1/tracking_links/:tracking_code/tracking_data (tracking_data_api_v1_tracking_link)
      def tracking_data
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
    end
  end
end
