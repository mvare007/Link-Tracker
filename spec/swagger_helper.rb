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
      openapi: '3.0.3',
      info: {
        title: 'Link Tracker API',
        version: 'v1'
      },
      paths: {},
      tags: [
        { name: 'Tracking Links' },
        { name: 'Clients' },
        { name: 'Links' }
      ],
      host: 'localhost:3010',
      servers: [
        {
          url: '{protocol}://{defaultHost}',
          variables: {
            protocol: {
              default: :http
            },
            defaultHost: {
              default: 'localhost:3010'
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
              tracking_code: { type: :string, description: 'Unique code to track visits' },
              client_id: { type: :integer }
            },
            required: %w[id tracking_code client_id],
            example: {
              id: 1,
              tracking_code: 'abc123',
              client_id: 1
            }
          },
          client: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string, description: 'Name of the client' },
              store_url: { type: :string, description: 'URL of the client store to redirect to' }
            },
            required: %w[id name store_url],
            example: {
              id: 1,
              name: 'Capsule Corp.',
              store_url: 'example.com'
            }
          },
          visit: {
            type: :object,
            properties: {
              id: { type: :integer },
              ip_address: { type: :string },
              user_agent: { type: :string }
            },
            required: %w[id ip_address user_agent],
            example: {
              id: 1,
              ip_address: '116.107.5.114',
              user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
            }
          },
          error_object: {
            type: :object,
            properties: {
              errors: {
                oneOf: [
                  { type: :string },
                  {
                    type: :object,
                    properties: {
                      field: { type: :array, items: { type: :string }, minItems: 0 }
                    }
                  }
                ],
                description: 'Object containing error messages for each field'
              }
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
