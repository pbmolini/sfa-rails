# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->
  # disable auto discover
  Dropzone.autoDiscover = false

  # grap our upload form by its id
  $("#boat_pictures_upload").dropzone
    url: "/boats/#{$('#boat_pictures_upload').data('id')}/pictures"
    # restrict image size to a maximum 1MB
    maxFilesize: 10
    # changed the passed param to one accepted by
    # our rails app
    paramName: "picture[image]"
    # show remove links on each image upload
    addRemoveLinks: true
    # if the upload was successful
    success: (file, response) ->
      # find the remove button link of the uploaded file and give it an id
      # based of the fileID response from the server
      $(file.previewTemplate).find('.dz-remove').attr('id', response.fileID)
      # add the dz-success class (the green tick sign)
      $(file.previewElement).addClass("dz-success")
    #when the remove button is clicked
    removedfile: (file) ->
      # grap the id of the uploaded file we set earlier
      id = $(file.previewTemplate).find('.dz-remove').attr('id')
      # make a DELETE ajax request to delete the file
      $.ajax
        type: 'DELETE'
        url: "/boats/#{$('#boat_pictures_upload').data('id')}/pictures/#{id}"
        success: (data) ->
          console.log(data.message)

  $('.picture-delete').on 'click', (event) ->
    event.preventDefault()
    if confirm('Are you sure?')#TODO: add gettext js
      $.ajax
        type: 'DELETE'
        url: "#{$(@).data('url')}.json"
        success: () =>
          $(@).closest('.col-md-4').fadeOut
            complete: () ->
              @remove()