# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.fn.extend
  bookingForm: (dates) ->
    # DATES ARE SORTED BY RUBY
    datesToEnable = _.map dates, (d) -> moment(new Date(d.date))

    startTimePicker = @find('.booking_start_time .form-control').datetimepicker
      format: 'DD/MM/YYYY'
      enabledDates: datesToEnable
      inline: true
      keepOpen: true

    endTimePicker = @find('.booking_end_time .form-control').datetimepicker
      format: 'DD/MM/YYYY'
      enabledDates: datesToEnable
      inline: true
      keepOpen: true

    @find(".booking_start_time .form-control").on "dp.change", (e) =>
      minDate = e.date
      maxDate = _.reduce(datesToEnable, (memo, d) ->
        if Math.floor(moment.duration(d.diff(memo)).as('days')) == 1
          memo = d
        else
          memo
      , e.date)
      endTimePicker.data("DateTimePicker").minDate(minDate)
      endTimePicker.data("DateTimePicker").maxDate(maxDate)

    @find(".booking_end_time .form-control").on "dp.change", (e) =>
      minDate = _.reduce(datesToEnable, (memo, d) ->
        if Math.floor(moment.duration(d.diff(memo)).as('days')) == -1
          memo = d
        else
          memo
      , e.date)
      maxDate = e.date
      startTimePicker.data("DateTimePicker").minDate(minDate)
      startTimePicker.data("DateTimePicker").maxDate(maxDate)