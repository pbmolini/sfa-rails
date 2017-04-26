$(document).on 'turbolinks:load', ->
  if $('#boat_details, #boat_features').length > 0
    $('#boat_details, #boat_features').on({
      'ajax:send': =>
        $(@).find('.saving').fadeIn()
      'ajax:success': =>
        $(@).find('.last-update').html("#{__('Last update:')} #{moment(new Date()).format('DD MMM H:mm')}")
      'ajax:complete': =>
        $(@).find('.saving').fadeOut()
    })

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
