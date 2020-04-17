# frozen_string_literal: true

module Staff
  class CustomerForm
    include ActiveModel::Model
    attr_accessor :customer, :inputs_home_address, :inputs_work_address

    delegate :persisted?, :save, to: :customer

    def initialize(customer = nil)
      @customer = customer
      @customer ||= Customer.new(gender: 'male')
      @customer.build_home_address unless @customer.home_address
      @customer.build_work_address unless @customer.work_address
    end
  end
end
