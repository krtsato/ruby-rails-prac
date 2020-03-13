Rails.application.configure do
  config.hosts << ENV["CUSTOMER_HOST_NAME"]
  config.hosts << ENV["STAFF_HOST_NAME"]
end

