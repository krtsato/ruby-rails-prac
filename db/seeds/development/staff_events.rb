staff_members = StaffMember.all

256.times do |n|
  staff = staff_members.sample # staff_members 配列から要素１つをランダム抽出
  event = staff.events.build

  if staff.active?
    if n.even? # 偶数のとき
      event.type = "logged_in"
    else
      event.type = "logged_out"
    end
  else
    event.type = "rejected"
  end

  event.occurred_at = (256 - n).hours.ago
  event.save!
end
