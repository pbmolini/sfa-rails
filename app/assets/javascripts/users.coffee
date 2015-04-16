$(document).ready () ->
  if $('.user_birthdate .form-control').length
    $('.user_birthdate .form-control').datetimepicker
      format: 'LL' #see http://momentjs.com/docs/#/displaying/format/
      useCurrent: true
      defaultDate: moment().subtract(16, 'years')
      maxDate: moment().subtract(16, 'years')