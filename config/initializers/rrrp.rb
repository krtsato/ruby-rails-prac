Rails.application.configure do
  config.rrrp = {
    admin: {host: ENV['ADMIN_STAFF_HOST_NAME'], path: 'admin'},
    staff: {host: ENV['ADMIN_STAFF_HOST_NAME'], path: ''},
    customer: {host: ENV['CUSTOMER_HOST_NAME'], path: 'mypage'}
  }
end
