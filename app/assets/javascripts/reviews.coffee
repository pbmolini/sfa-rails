# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.countChar = (e) ->
  textarea = $(e.target)
  len = textarea.val().length
  if (len < 42)
  	$('#comment-min-length').text(42 - len)
  	$('#char-to-go').show()
  else
  	$('#char-to-go').hide()

  if (len > 512) 
    textarea.val(textarea.val().substring(0, 512))
  else 
  	$('#comment-max-length').text(512 - len)
  