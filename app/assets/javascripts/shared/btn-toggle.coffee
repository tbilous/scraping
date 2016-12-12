$ ->
  $(document).on 'click', '.script-item-toggle', (e) ->
    toggleBtn = $(document).find(this)
    item = $(toggleBtn.data('target'))

    item.slideToggle('fast')
    return

#$(document).on("turbolinks:load", ready)
