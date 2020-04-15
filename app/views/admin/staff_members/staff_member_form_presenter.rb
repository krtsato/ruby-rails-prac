# frozen_string_literal: true

class StaffMemberFormPresenter < FormPresenter
  def full_name_block(f_name, g_name, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << label(f_name, label_text, class: options[:required] ? 'required' : nil)
      m << text_field(f_name, options)
      m << text_field(g_name, options)
    end
  end
end
