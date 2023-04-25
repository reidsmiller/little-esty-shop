class HolidaySearch
  def upcoming_three_holidays
    holidays = service.holidays.map do |holiday|
      Holiday.new(holiday)
    end
    holidays[0..2]
  end

  def service
    NagerService.new
  end
end