# frozen_string_literal: true

class StaffMemberPresenter < ModelPresenter
  delegate :suspended?, :family_name, :given_name, :family_name_kana, :given_name_kana, to: :object

  def full_name
    family_name + ' ' + given_name
  end

  def full_name_kana
    family_name_kana + ' ' + given_name_kana
  end

  # 職員の停止フラグの On/Off を表現する記号を返す
  def suspended_mark
    suspended? ? sanitize('&#x2611;') : sanitize('&#x2610;')
  end
end
