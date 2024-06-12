module Api
	module V1
		class ClientsController < ApplicationController
			def create
				@client = Client.new(client_params)
				if @client.save
					render :show, status: :created
				else
					render json: { errors: @client.errors }, status: :unprocessable_entity
				end
			end

			def show
				@client = Client.find(params[:id])
			end

			private

			def client_params
				params.require(:client).permit(:name, :store_url)
			end
		end
	end
end
