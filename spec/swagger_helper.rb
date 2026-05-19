require 'rails_helper'

RSpec.configure do |config|
  #φάκελος swagger JSON αρχείου
  config.swagger_root = Rails.root.join('swagger').to_s

  #swagger documentation
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Todo API',
        version: 'v1',
        description: 'REST API για διαχείριση todos και todo items'
      },
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        }
      ]
    }
  }

  #μορφή παραγωγής του αρχείου
  config.swagger_format = :yaml
end