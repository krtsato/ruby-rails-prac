# frozen_string_literal: true

class StaffMemberFormPresenter < UserFormPresenter
  # アカウント停止
  def suspended_check_box
    markup(:div, class: 'check-boxes') do |m|
      m << check_box(:suspended)
      m << label(:suspended, 'アカウント停止')
    end
  end
end
