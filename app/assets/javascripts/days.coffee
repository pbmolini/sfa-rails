$.fn.extend
  availabilityCalendar: (days_path) ->
    new AvailabilityCalendar(@, days_path)

class AvailabilityCalendar

  constructor: (@el, @rest_path, days = []) ->
    @cal = @el.find('#calendar').calendario
      weeks: moment.weekdays()
      weekabbrs: moment.weekdaysShort()
      months: moment.months()
      monthabbrs: moment.monthsShort()
      caldata: days
      onDayClick: @onDayClick

    @month = @el.find('#custom-month').html @cal.getMonthName()
    @year = @el.find('#custom-year').html @cal.getYear()

    # Ricordati di aggiungere .json qui e non metterlo in html.erb
    # Mi serve rest_path come base da altre parti (fai CTRL+F per scoprire dove!)
    $.ajax(url: "#{@rest_path}.json", dataType: 'json')
    .success (days_data) =>
      @cal.caldata = days_data
      @setUnavailable()

    @el.find('#custom-next').on 'click', () =>
      @cal.gotoNextMonth(@updateMonthYear)

    @el.find('#custom-prev').on 'click', () =>
      if ((@cal.getMonth() - 1 > moment().month()) && (@cal.getYear() == moment().year())) || (@cal.getYear() > moment().year())
        @cal.gotoPreviousMonth(@updateMonthYear)

  _toDate: (dateProperties) ->
    moment(new Date("#{dateProperties.year}-#{dateProperties.month}-#{dateProperties.day}"))

  _getData: (date) =>
    d = if typeof date == 'string' then date else date.format("YYYY-MM-DD")
    @cal.caldata[d]

  onDayClick: (element, content, dateProperties) =>
    date = @_toDate(dateProperties)
    if date.isAfter(moment(), 'day')
      dateData = @_getData(date) || { availability: 'available' }
      switch dateData.availability
        when 'unavailable', 'available' then @updateDays(element, dateProperties)
        when 'pending', 'accepted' then @goToBooking(dateProperties)

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
    _.each @cal.caldata, (day_properties, date) =>
      $cell = @getCell(date)
      # $cell.addClass('unavailable-day') if $cell && day_properties.availability == 'unavailable'
      $cell.addClass("#{day_properties.availability}-day") if $cell
      if $cell && day_properties.booking_id
        $cell.addClass('booked-day')

  # removes the class .unavailable-day from every unavailable day
  resetUnavailable: () =>
    @el.find('unavailable-day').removeClass('unavailable-day')

  # TODO: THIS IS NOT NEEDED ANYMORE BUT MAY BE USEFUL TO MARK DAYS AS BOOKED
  # reads from @cal.caldata all the dates that are available in the current month
  # setAvailable: () =>
  #   _.each @cal.caldata, (day_properties, date) =>
  #     $cell = @getCell(date)
  #     $cell.addClass('available-day') if $cell &&

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
    # @setAvailable()

  # sets days as available or undefined and syncs with the server
  updateDays: (element, dateProperties) =>
    date = @_toDate(dateProperties).format("YYYY-MM-DD")
    dateData = @_getData(date)
    dayId = dateData.id if dateData
    if dayId
      $.ajax
        url: "#{@rest_path}/#{dayId}"
        method: 'DELETE'
        dataType: 'json'
        success: (data) =>
          if data.success
            $(element).removeClass('unavailable-day')
            delete @cal.caldata[date]
    else
      $.ajax
        url: @rest_path
        method: 'POST'
        dataType: 'json'
        data:
          day:
            date: date
            availability: 'unavailable'
        success: (data) =>
          if data.success
            $(element).addClass('unavailable-day')
            @cal.caldata[date] = { availability: 'unavailable', id: data.day.id }

  goToBooking: (dateProperties) =>
    dateData = @_getData(@_toDate(dateProperties))
    boatId = dateData.boat_id
    bookingId = dateData.booking_id
    window.location.assign @rest_path.replace("/days", "/bookings/#{bookingId}")
