# frozen_string_literal: true

module Staff
  class CustomerForm
    include ActiveModel::Model
    attr_accessor :customer, :inputs_home_address, :inputs_work_address

    delegate :persisted?, :save, to: :customer

    def initialize(customer = nil)
      @customer = customer
      @customer ||= Customer.new(gender: 'male')

      self.inputs_home_address = @customer.home_address.present?
      self.inputs_work_address = @customer.work_address.present?
      @customer.build_home_address unless @customer.home_address
      @customer.build_work_address unless @customer.work_address

      # 電話番号の任意入力において不足分のモデルオブジェクトを作成
      [@customer.personal_phones, @customer.home_address.phones, @customer.work_address.phones].each do |phones|
        build_blank_phone_numbers(phones)
      end
    end

    def assign_attributes(params = {})
      @params = params
      self.inputs_home_address = params[:inputs_home_address] == '1'
      self.inputs_work_address = params[:inputs_work_address] == '1'

      customer.assign_attributes(customer_params)
      personal_phone_assign_divider
      home_address_assign_divider(inputs_home_address)
      work_address_assign_divider(inputs_work_address)
    end

    private

    def customer_params
      @params.require(:customer).except(:phones).permit(
        :email, :password, :family_name, :given_name,
        :family_name_kana, :given_name_kana, :birthday, :gender
      )
    end

    def home_address_params
      @params.require(:home_address).except(:phones).permit(:postal_code, :prefecture, :city, :address1, :address2)
    end

    def work_address_params
      @params.require(:work_address).except(:phones).permit(
        :postal_code, :prefecture, :city, :address1, :address2, :company_name, :division_name
      )
    end

    def phone_params(record_name)
      @params.require(record_name).slice(:phones).permit(phones: %i[number primary])
    end

    def build_blank_phone_numbers(phones)
      (2 - phones.size).times do
        phones.build
      end
    end

    # ここどうにかする
    def phone_number_assign_divider(customer_phones, fetched_phones)
      customer_phones.size.times do |index|
        attributes = fetched_phones[index.to_s]
        if attributes && attributes[:number].present?
          customer_phones[index].assign_attributes(attributes)
        else
          customer_phones[index].mark_for_destruction
        end
      end
    end

    def home_address_assign_divider(is_home_address)
      if is_home_address
        customer.home_address.assign_attributes(home_address_params)
        fetched_phones = phone_params(:home_address).fetch(:phones)
        phone_number_assign_divider(customer.home_address.phones, fetched_phones)
      else
        customer.home_address.mark_for_destruction
      end
    end

    def work_address_assign_divider(is_work_address)
      if is_work_address
        customer.work_address.assign_attributes(work_address_params)
        fetched_phones = phone_params(:work_address).fetch(:phones)
        phone_number_assign_divider(customer.work_address.phones, fetched_phones)
      else
        customer.work_address.mark_for_destruction
      end
    end

    def personal_phone_assign_divider
      fetched_phones = phone_params(:customer).fetch(:phones)
      phone_number_assign_divider(customer.personal_phones, fetched_phones)
    end
  end
end
