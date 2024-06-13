require 'swagger_helper'

RSpec.describe 'Tracking Links API V1 Endpoints' do
  path '/api/v1/tracking_links' do
    get 'Retrieves a paginated list of tracking_links' do
      tags 'Tracking Links'.freeze

      consumes 'application/json'
      produces 'application/json'

      parameter name: :store_url, in: :query, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false

      let(:page) { 1 }

      response 200, 'success' do
        let(:client) { create(:client) }
        let(:store_url) { client.store_url }
        schema type: :object,
               properties: { tracking_links: { type: :array,
                                               items: { '$ref' => '#/components/schemas/tracking_link' } } },
               required: ['tracking_links']

        # rubocop:disable FactoryBot/ExcessiveCreateList
        before do
          create_list(:tracking_link, 40, client:)
        end
        # rubocop:enable FactoryBot/ExcessiveCreateList

        run_test! do |response|
          expect(response.parsed_body['tracking_links'].size).to eq(20)
        end
      end

      response 422, 'unprocessable entity' do
        let(:store_url) { nil }
        schema '$ref' => '#/components/schemas/error_object'
        run_test!
      end
    end

    post 'Creates a tracking_link' do
      tags 'Tracking Links'.freeze

      consumes 'application/json'
      produces 'application/json'

      parameter name: :store_url, in: :query, type: :string, required: true

      let(:client) { create(:client) }
      let(:store_url) { client.store_url }

      response 201, 'created' do
        schema type: :object,
               properties: { tracking_link: { '$ref' => '#/components/schemas/tracking_link' } },
               required: ['tracking_link']

        run_test! do |response|
          persisted_tracking_link = response.parsed_body['tracking_link']

          expect(persisted_tracking_link['tracking_code']).to be_present
          expect(persisted_tracking_link['client_id']).to eq(client.id)
        end
      end

      context 'when client does not exist' do
        let(:store_url) { 'nonexistent.com' }

        response 422, 'unprocessable entity' do
          schema '$ref' => '#/components/schemas/error_object'

          run_test! do |response|
            expect(response.parsed_body).to eq({ 'errors' => 'Client not found' })
          end
        end
      end
    end
  end

  path '/api/v1/tracking_links/{tracking_code}' do
    get 'Retrieves a tracking_link' do
      tags 'Tracking Links'.freeze

      consumes 'application/json'
      produces 'application/json'

      parameter name: :tracking_code, in: :path, type: :string, required: true

      response 200, 'success' do
        let(:tracking_code) { create(:tracking_link).tracking_code }
        schema type: :object,
               properties: { tracking_link: { '$ref' => '#/components/schemas/tracking_link' } },
               required: ['tracking_link']
        run_test!
      end

      response 422, 'unprocessable entity' do
        let(:tracking_code) { nil }
        schema '$ref' => '#/components/schemas/error_object'
        run_test!
      end
    end
  end

  path '/api/v1/tracking_links/{tracking_code}/tracking_data' do
    get 'Retrieves a paginated list of visits for a tracking_link' do
      tags 'Tracking Links'.freeze

      consumes 'application/json'
      produces 'application/json'

      parameter name: :tracking_code, in: :path, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false

      let(:page) { 1 }

      response 200, 'success' do
        let(:tracking_link) { create(:tracking_link) }
        let(:tracking_code) { tracking_link.tracking_code }
        schema type: :object,
               properties: { visits: { type: :array, items: { '$ref' => '#/components/schemas/visit' } } },
               required: ['visits']

        # rubocop:disable FactoryBot/ExcessiveCreateList
        before do
          create_list(:visit, 40, tracking_link:)
        end
        # rubocop:enable FactoryBot/ExcessiveCreateList

        run_test! do |response|
          expect(response.parsed_body['visits'].size).to eq(20)
        end
      end

      response 422, 'unprocessable entity' do
        let(:tracking_code) { nil }
        schema '$ref' => '#/components/schemas/error_object'
        run_test!
      end
    end
  end
end
