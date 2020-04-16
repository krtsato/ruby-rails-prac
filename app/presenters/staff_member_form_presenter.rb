# frozen_string_literal: true

class StaffMemberFormPresenter < FormPresenter
  # オーバーライド
  def password_field_block(input, label_text, options = {})
    if object.new_record?
      super(input, label_text, options)
    end
  end

  # 姓名
  def full_name_block(family_name, given_name, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(family_name, label_text, options)
      m << text_field(family_name, options)
      m << text_field(given_name, options)
      m << error_messages_for(family_name)
      m << error_messages_for(given_name)
    end
  end

  # アカウント停止
  def suspended_check_box
    markup(:div, class: 'check-boxes') do |m|
      m << check_box(:suspended)
      m << label(:suspended, 'アカウント停止')
    end
  end
end
