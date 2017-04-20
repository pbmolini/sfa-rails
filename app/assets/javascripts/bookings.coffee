# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class BookingForm

  constructor: (@el, boatId) ->
    # private methods

    # given a start date it blocks all the dates after the first blocked day
    # this means that it ensures that the user cannot book blocked days
    restrictEndDate = (startDate) =>
      maxDate = undefined

      for d in @datesToDisable
        if Math.floor(moment.duration(d.diff(startDate)).as('days')) > 0
          maxDate = d
          break

      # NOTE: start date always wins. whenever you change it, the end date is cleared
      @endTimePicker.clear()
      @endTimePicker.minDate(startDate)
      @endTimePicker.maxDate(maxDate.hour(23).minutes(59).seconds(59)) if maxDate
      # why? you may ask... that's because bootstrap datetimepicker always reasons using date and time
      # so maxDate must be the latest possible time within the max date

    animateHidePicker = (picker) ->
      picker.siblings().find('.fa').removeClass('fa-rotate-90')
      picker.height(0).css('visibility','hidden')

    animateShowPicker = (picker) ->
      picker.siblings().find('.fa').addClass('fa-rotate-90')
      picker.height(300).css('visibility','visible')

    animateTogglePicker = (picker) ->
      if picker.height() == 0
        animateShowPicker(picker)
      else
        animateHidePicker(picker)

    animateTogglePickers = () =>
      _.each ['start_time-picker', 'end_time-picker'], (pickerId) =>
        picker = @el.find("##{pickerId}>.bootstrap-datetimepicker-widget")
        animateTogglePicker(picker)

    animateHideAllPickers = () =>
      _.each ['start_time-picker', 'end_time-picker'], (pickerId) =>
        picker = @el.find("##{pickerId}>.bootstrap-datetimepicker-widget")
        animateHidePicker(picker)

    __formatDate = (date) =>
      moment(date).format('DD/MM/YYYY')

    # constructor logic

    # first of all remove ALL event listeners that may be still there
    @el.children().off()

    # then ask the server for the dates to disable for this boat
    $.get "/boats/#{boatId}/dates_to_disable.json", (dates) =>
      @datesToDisable = _.map dates, (d) ->
        moment(new Date(d.date))

      @startTimePicker = @el.find('#start_time-picker').datetimepicker
        locale: moment.locale()
        format: moment.localeData().longDateFormat('L')
        minDate: new Date()
        disabledDates: @datesToDisable
        inline: true
        showClear: true
      .on "dp.change", (e) =>
        if e.date
          @el.find("#start_time-link .booking-date-picker-label").html "<strong>#{__('Start')}:</strong> #{moment(e.date).format('DD/MM/YYYY')}"
          @el.find('#booking_start_time').val(moment(e.date).hour(0).minutes(0).seconds(0))
          restrictEndDate(e.date)
          animateTogglePickers()
        else
          @el.find("#start_time-link .booking-date-picker-label").html __('Select a start date')
          @endTimePicker.clear()
      .data("DateTimePicker")

      @endTimePicker = @el.find('#end_time-picker').datetimepicker
        locale: moment.locale()
        format: moment.localeData().longDateFormat('L')
        disabledDates: @datesToDisable
        minDate: new Date()
        inline: true
        showClear: true
        useCurrent: false #IMPORTANT
      .on "dp.change", (e) =>
        if e.date
          @el.find("#end_time-link .booking-date-picker-label").html "<strong>#{__('End')}:</strong> #{moment(e.date).format('DD/MM/YYYY')}"
          @el.find('#booking_end_time').val(moment(e.date).hour(23).minutes(59).seconds(59))
          animateHideAllPickers()
        else
          @el.find("#end_time-link .booking-date-picker-label").html __('Select an end date')
      .data("DateTimePicker")

      # hide the end time picker when the page is loaded
      @el.find('#end_time-picker>.bootstrap-datetimepicker-widget').height(0);

      @el.find("#start_time-link, #end_time-link").on 'click', (e) ->
        e.preventDefault()
        animateTogglePicker($(@).closest('.booking-date-picker').find('.bootstrap-datetimepicker-widget'))

      @el.find('#booking_people_on_board').slider
        tooltip: 'always'
        value: 1
        # min: parseInt(@el.find('#booking_people_on_board').prop('min'))
        # max: parseInt(@el.find('#booking_people_on_board').prop('max'))
        # width: '100%'

$.fn.extend
  bookingForm: (boatId) ->
    new BookingForm(@, boatId)
