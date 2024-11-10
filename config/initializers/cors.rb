Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000', 'http://localhost:5173'
    resource '*', headers: :any, methods: %i[get post put patch options delete], expose: [:Authorization]
  end
end
