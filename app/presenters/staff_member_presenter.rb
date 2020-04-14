# frozen_string_literal: true

class StaffMemberPresenter < ModelPresenter
  delegate :suspended?, to: :object

  # 職員の停止フラグの On/Off を表現する記号を返す
  def suspended_mark
    suspended? ? sanitize('&#x2611;') : sanitize('&#x2610;')
  end
end
