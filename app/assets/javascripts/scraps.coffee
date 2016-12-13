ready = ->

  searchForm = $('#searchBooking')
  dataContainer = $('#searchData')

  searchForm.on 'ajax:success', (e, data, status, xhr) ->
    $(dataContainer).each ->
      $('.search-grid').detach()
    for i in data
      $(dataContainer).prepend App.utils.render('booking', i)
      console.log i
    FormForClear = $(document).find(this)
    $(FormForClear)[0].reset();
    $(FormForClear).toggle()

  searchForm.on 'ajax:error', (e, data, status, xhr) ->
    message =  data.responseJSON.errors
    for key,value of message
      message = value
      App.utils.errorMessage(message)

$(document).on("turbolinks:load", ready)
