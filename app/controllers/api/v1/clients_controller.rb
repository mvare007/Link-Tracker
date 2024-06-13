module Api
  module V1
    class ClientsController < ApplicationController
      # @route GET /api/v1/clients/:id (api_v1_client)
      def show
        @client = Client.find(params[:id])
      end

      # @route POST /api/v1/clients (api_v1_clients)
      def create
        @client = Client.new(client_params)
        if @client.save
          render :show, status: :created
        else
          render json: { errors: @client.errors }, status: :unprocessable_entity
        end
      end

      private

      def client_params
        params.require(:client).permit(:name, :store_url)
      end
    end
  end
end
