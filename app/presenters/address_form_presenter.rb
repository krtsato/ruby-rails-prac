# frozen_string_literal: true

class AddressFormPresenter < FormPresenter
  def postal_code_block(input, label_text, options)
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(input, label_text, options)
      m << text_field(input, options)
      m.span ' (7桁の半角数字で入力してください。)', class: 'notes'
      m << error_messages_for(input)
    end
  end
end
