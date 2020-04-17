module Staff
  class CustomersController < Base
    def index
      @customers = Customer.order(:family_name_kana, :given_name_kana).page(params[:page])
    end
  end
end
