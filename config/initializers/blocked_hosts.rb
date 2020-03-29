Rails.application.configure do
  config.hosts << 'localhost'
  config.hosts << ENV['CUSTOMER_HOST_NAME']
  config.hosts << ENV['ADMIN_STAFF_HOST_NAME']
end
