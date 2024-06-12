# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'http://localhost:3010'
            }
          }
        }
      ],
      components: {
        schemas: {
          tracking_link: {
            type: :object,
            properties: {
              id: { type: :integer },
              tracking_code: { type: :string, description: 'Unique code to track visits'},
              target_url: { type: :string, description: 'URL to redirect to'},
              client_id: { type: :integer }
            },
            required: %w[id tracking_code target_url client_id],
            example: {
              id: 1,
              tracking_code: 'abc123',
              target_url: 'https://example.com',
              client_id: 1
            }
          },
          client: {
            type: :object,
            properties: {
              id: { type: :integer },
              store_url: { type: :string, description: 'URL of the client store' }
            },
            required: %w[id store_url],
            example: {
              id: 1,
              store_url: 'example.com'
            }
          },
          visit: {
            type: :object,
            properties: {
              id: { type: :integer },
              tracking_link_id: { type: :integer },
              ip_address: { type: :string },
              user_agent: { type: :string }
            },
            required: %w[id tracking_link_id ip_address user_agent],
            example: {
              id: 1,
              tracking_link_id: 1,
              ip_address: '116.107.5.114',
              user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :json
end
