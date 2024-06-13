require 'swagger_helper'

RSpec.describe 'Links Endpoints' do
  path '/{tracking_code}' do
    get 'Creates a visit and redirects to the client store url' do
      tags 'Links'.freeze

      consumes 'application/json'
      produces 'application/json'

      parameter name: :tracking_code, in: :path, type: :string, required: true

      response 302, 'found' do
        let(:tracking_link) { create(:tracking_link) }
        let(:tracking_code) { tracking_link.tracking_code }

        run_test! do |response|
          expect(response).to redirect_to(tracking_link.client_store_url)
        end
      end

      response 422, 'unprocessable entity' do
        let(:tracking_code) { '1234' }
        schema '$ref' => '#/components/schemas/error_object'
        run_test!
      end
    end
  end
end
