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

    def create
      @customer_form = CustomerForm.new
      @customer_form.assign_attributes(params[:form])
      if @customer_form.save
        go_to_staff_customer_root('顧客を追加しました')
      else
        back_to_customer_form('new', '入力に誤りがあります')
      end
    end

    def update
      @customer_form = CustomerForm.new(Customer.find(params[:id]))
      @customer_form.assign_attributes(params[:form])
      if @customer_form.save
        go_to_staff_customer_root('顧客情報を更新しました')
      else
        back_to_customer_form('edit', '入力に誤りがあります')
      end
    end

    def destroy
      customer = Customer.find(params[:id])
      customer.destroy!
      go_to_staff_customer_root('顧客アカウントを削除しました')
    end

    private

    def go_to_staff_customer_root(notice_text)
      flash.notice = notice_text
      redirect_to :staff_customers
    end

    def back_to_customer_form(action, alert_text)
      flash.now.alert = alert_text
      render action: action
    end
  end
end
