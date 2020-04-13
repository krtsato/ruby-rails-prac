# frozen_string_literal: true

module Staff
  class PasswordsController < Base
    def show
      redirect_to :edit_staff_password
    end

    def edit
      @change_password_form = ChangePasswordForm.new(object: current_staff_member)
    end

    def update
      @change_password_form = ChangePasswordForm.new(staff_member_params)
      @change_password_form.object = current_staff_member
      if @change_password_form.save
        flash.now.notice = 'パスワードを変更しました'
        redirect_to :staff_account
      else
        flash.now.alert = '入力に誤りがあります'
        render action: 'edit'
      end
    end

    private

    def staff_member_params
      params.require(:staff_change_password_form).permit(
        :current_password, :new_password, :new_password_confirmation
      )
    end
  end
end
