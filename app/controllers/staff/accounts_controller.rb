module Staff
  class AccountsController < Base
    def show
      @staff_member = current_staff_member
    end
  end
end
