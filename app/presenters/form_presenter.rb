# frozen_string_literal: true

require 'html_builder'

class FormPresenter
  include HtmlBuilder
  attr_reader :form_builder, :view_context

  delegate \
    :label, :text_field, :date_field, :password_field, :check_box, :radio_button, :text_area, :sanitize, :object,
    to: :form_builder

  # インスタンス化
  def initialize(form_builder, view_context)
    @form_builder = form_builder
    @view_context = view_context
  end

  # 入力必須
  def notes
    markup(:div, class: 'notes') do |m|
      m.span '*', class: 'mark'
      m.text '印の付いた項目は入力必須です。'
    end
  end

  # 文字入力
  def text_field_block(input, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(input, label_text, options)
      m << text_field(input, options)
      m << error_messages_for(input)
    end
  end

  # パスワード
  def password_field_block(input, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(input, label_text, options)
      m << password_field(input, options)
      m << error_messages_for(input)
    end
  end

  # 日付
  def date_field_block(input, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(input, label_text, options)
      m << date_field(input, options)
      m << error_messages_for(input)
    end
  end


  private

  def decorated_label(input, label_text, options = {})
    label(input, label_text, class: options[:required] ? 'required' : nil)
  end
end
