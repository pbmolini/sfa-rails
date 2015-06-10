# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.fn.extend
  engine_check: () ->
    this.on 'change', () ->
      if $(@).is(':checked')
        $('#boat_horse_power').removeAttr("readonly").val("<%= @boat.horse_power %>")
        $('.boat_horse_power > label').text __('Engine Horse Power')
      else
        $('#boat_horse_power').attr("readonly", "readonly").val("0")
        $('.boat_horse_power > label').text __('No Engine')

  toggleInBoardEngine: () ->
    @.on 'change', () ->
      if ($('#boat_boat_features_set_attributes_outboard_engine').is(':checked') && $("#boat_boat_features_set_attributes_inboard_engine").is(':checked'))
        $("#boat_boat_features_set_attributes_inboard_engine").prop("checked", false)

  toggleOutBoardEngine: () ->
    @.on 'change', () ->
      if ($('#boat_boat_features_set_attributes_outboard_engine').is(':checked') && $("#boat_boat_features_set_attributes_inboard_engine").is(':checked'))
        $("#boat_boat_features_set_attributes_outboard_engine").prop("checked", false)