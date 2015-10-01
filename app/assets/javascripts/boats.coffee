# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.fn.extend
  engine_check: (boat_horse_power) ->
    @on 'change', (e) ->
      e.stopPropagation()
      if $(@).is(':checked')
        $('#boat_horse_power').removeAttr("readonly").val(boat_horse_power)
        $('.boat_horse_power > label').text __('Engine Horse Power')
      else
        $('#boat_horse_power').attr("readonly", "readonly").val(0)
        $('.boat_horse_power > label').text __('No Engine')
      $('form').submit()

  toggleInBoardEngine: () ->
    @on 'change', () ->
      if ($('#boat_boat_features_set_attributes_outboard_engine').is(':checked') && $("#boat_boat_features_set_attributes_inboard_engine").is(':checked'))
        $("#boat_boat_features_set_attributes_inboard_engine").prop("checked", false)

  toggleOutBoardEngine: () ->
    @on 'change', () ->
      if ($('#boat_boat_features_set_attributes_outboard_engine').is(':checked') && $("#boat_boat_features_set_attributes_inboard_engine").is(':checked'))
        $("#boat_boat_features_set_attributes_outboard_engine").prop("checked", false)

  initEngineField: (hasEngineOrIsNew) ->
    if hasEngineOrIsNew
      $('#engine-presence').prop 'checked', true
    else
      $('#boat_horse_power').attr("readonly", "readonly").val("0")
      $('.boat_horse_power > label').text(__('No Engine'))

  boatYearField: () ->
    @datetimepicker
      viewMode: 'years'
      format: 'YYYY'
      minDate: moment().year(1900)
      maxDate: moment()
    .on 'dp.change', () =>
      @closest('form').submit()

$(document).ready ->
  $('.boat-photos-carousel').slick
    infinite: true
    adaptiveHeight: true
    lazyload: 'ondemand'
    slidesToShow: 1
    slidesToScroll: 1
    autoplay: false
    autoplaySpeed: 5000
    dots: true
    variableWidth: true
