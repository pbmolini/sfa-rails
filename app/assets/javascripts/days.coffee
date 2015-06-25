$.fn.extend
  availabilityCalendar: (path, days) ->
    new AvailabilityCalendar(@, path, days)

class AvailabilityCalendar

  constructor: (@el, @rest_path, days = []) ->
    @cal = @el.find('#calendar').calendario
      weeks: moment.weekdays()
      weekabbrs: moment.weekdaysShort()
      months: moment.months()
      monthabbrs: moment.monthsShort()
      caldata: days
      onDayClick: (element, content, dateProperties) =>
        @updateDays(element, dateProperties) if moment(new Date("#{dateProperties.year}-#{dateProperties.month}-#{dateProperties.day}")).isAfter(moment(), 'day')

    @month = @el.find('#custom-month').html @cal.getMonthName()
    @year = @el.find('#custom-year').html @cal.getYear()

    # $(document).on 'shown.calendar.calendario', (e, instance) =>
    @setUnavailable()
    @setAvailable()

    @el.find('#custom-next').on 'click', () =>
      @cal.gotoNextMonth(@updateMonthYear)

    @el.find('#custom-prev').on 'click', () =>
      if ((@cal.getMonth() - 1 > moment().month()) && (@cal.getYear() == moment().year())) || (@cal.getYear() > moment().year())
        @cal.gotoPreviousMonth(@updateMonthYear)

  # overrides Calendario's getCell that appears to be broken
  # date is a string YYYY-MM-DD
  getCell: (date) =>
    day = moment(new Date(date)).date().toString()
    month = moment(new Date(date)).month() + 1
    if month == @cal.getMonth()
      @el.find("#calendar span.fc-date").filter(() -> $(@).text() == day).parent()
    else
      undefined

  # sets as unavailable all the dates before today
  # TODO: set reserved dates as unavailable
  setUnavailable: () =>
    today = @el.find('.fc-today')
    today.prevAll('div').addClass('unavailable-day')
    today.closest('.fc-row').prevAll('.fc-row').find('div').addClass('unavailable-day')

  # removes the class .unavailable-day from every unavailable day
  resetUnavailable: () =>
    @el.find('unavailable-day').removeClass('unavailable-day')

  # reads from @cal.caldata all the dates that are available in the current month
  setAvailable: () =>
    _.each @cal.caldata, (day_id, date) =>
      $cell = @getCell(date)
      $cell.addClass('available-day') if $cell

  # removes the .available-day from every available day
  resetAvailable: () =>
    @el.find('available-day').removeClass('available-day')

  # updates the month and year label and availabilities
  updateMonthYear: () =>
    @month.html @cal.getMonthName()
    @year.html @cal.getYear()
    @resetUnavailable()
    @setUnavailable()
    @resetAvailable()
    @setAvailable()

  # sets days as available or undefined and syncs with the server
  updateDays: (element, dateProperties) =>
    date = moment(new Date("#{dateProperties.year}-#{dateProperties.month}-#{dateProperties.day}")).format("YYYY-MM-DD")
    day_id = @cal.caldata[date]
    if day_id
      $.ajax
        url: "#{@rest_path}/#{day_id}"
        method: 'DELETE'
        dataType: 'json'
        success: (data) =>
          if data.success
            $(element).removeClass('available-day')
            delete @cal.caldata[date]
    else
      $.ajax
        url: @rest_path
        method: 'POST'
        dataType: 'json'
        data:
          day:
            date: date
        success: (data) =>
          if data.success
            $(element).addClass('available-day')
            @cal.caldata[date] = data.day.id