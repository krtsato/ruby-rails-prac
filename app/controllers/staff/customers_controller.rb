# frozen_string_literal: true

module Staff
  class CustomersController < Base
    def index
      @customers = Customer.order(:family_name_kana, :given_name_kana).page(params[:page])
    end

    def show
      @customer = Customer.find(params[:id])
    end

    def new
      @customer_form = CustomerForm.new
    end

    def edit
      @customer_form = CustomerForm.new(Customer.find(params[:id]))
    end
  end
end
