# $(document).on 'turbolinks:load', () ->
# 	# This code has been moved back to registrations/edit to use erb
#   if $('.user_birthdate .form-control').length
#     $('.user_birthdate .form-control').datetimepicker
#       format: 'YYYY-MM-DD' #see http://momentjs.com/docs/#/displaying/format/
#       #locale: 'it'
#       extraFormats: ['LL']
#       useCurrent: true
#       defaultDate: moment().subtract(16, 'years')
#       maxDate: moment().subtract(16, 'years')