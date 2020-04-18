# frozen_string_literal: true

require 'nkf'

module StringNormalizer
  extend ActiveSupport::Concern

  def normalize_as_email(text)
    NKF.nkf('-WwZ1', text).strip.downcase if text
  end

  def normalize_as_name(text)
    NKF.nkf('-WwZ1', text).strip if text
  end

  def normalize_as_furigana(text)
    NKF.nkf('-WwZ1 --katakana', text).strip if text
  end

  def normalize_as_postal_code(text)
    NKF.nkf('-WwZ1', text).strip.delete('-') if text
  end
end
