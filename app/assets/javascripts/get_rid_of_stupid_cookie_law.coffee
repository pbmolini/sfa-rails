$(window).one 'scroll', () ->
  if $('.cookies-eu').length
    $('.cookies-eu-ok').trigger 'click'
    console.log __('Hey! Thanks for reading this. Did you know that there is a stupid Cookie Law around? I hope you do, otherwise you might get fined by the evil governments of European countries. In any case take a look at http://cookie.tools to learn more.')