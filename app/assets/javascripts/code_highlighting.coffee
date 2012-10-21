$ ->
  $('.toolbar .toggle-line-numbers').click (evt)->
    evt.preventDefault()
    if $(this).hasClass('hidden')
      $(this).parent().prev().find('.line-number').show()
      $(this).removeClass('hidden')
    else
      $(this).parent().prev().find('.line-number').hide()
      $(this).addClass('hidden')
