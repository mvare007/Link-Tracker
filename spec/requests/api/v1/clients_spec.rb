require 'swagger_helper'

RSpec.describe 'Client API V1 Endpoints' do
  path '/api/v1/clients' do
    post 'Creates a client' do
      tags 'Clients'.freeze

      consumes 'application/json'
      produces 'application/json'

      parameter name: :client, in: :body, schema: { '$ref' => '#/components/schemas/client' }

      response(201, 'created') do
        let(:client) { attributes_for(:client) }

        schema type: :object, properties: { client: { '$ref' => '#/components/schemas/client' } },
               required: ['client']

        run_test! do |response|
          persisted_client = response.parsed_body['client']

          expect(persisted_client['store_url']).to eq(client[:store_url])
          expect(persisted_client['name']).to eq(client[:name])
        end
      end

      response(422, 'unprocessable entity') do
        let(:client) { { name: 'test' } }
        schema '$ref' => '#/components/schemas/error_object'

        run_test! do |response|
          expect(response.parsed_body).to eq({ 'errors' => { 'store_url' => ["can't be blank"] } })
        end
      end
    end
  end

  path '/api/v1/clients/{id}' do
    get 'Retrieves a client' do
      tags 'Clients'.freeze
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true

      response(200, 'ok') do
        let(:client) { create(:client) }
        let(:id) { client.id }

        schema type: :object, properties: { client: { '$ref' => '#/components/schemas/client' } },
               required: ['client']

        run_test! do |response|
          persisted_client = response.parsed_body['client']

          expect(persisted_client['store_url']).to eq(client.store_url)
          expect(persisted_client['name']).to eq(client.name)
        end
      end

      response(422, 'unprocessable entity') do
        let(:id) { 0 }
        schema '$ref' => '#/components/schemas/error_object'

        run_test! do |response|
          expect(response.parsed_body).to eq({ 'errors' => 'Client not found' })
        end
      end
    end
  end
end
