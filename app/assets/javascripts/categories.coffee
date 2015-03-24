# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on "click", "#step_toggle", ->
  $('.step_form').slideToggle(500)
  $('.examination_form').hide()


$(document).on "click", "#examination_toggle", ->
  $('.examination_form').slideToggle(500)
  $('.step_form').hide()


$(document).on "click", "#module_toggle", ->
  $('.module_form').slideToggle(500)


$(document).on "click", "#reply_toggle", ->
  $(this).parent().children('#reply_form').toggle('show')

$(document).on "click", "#comment_toggle", ->
  $('.comment_form').slideToggle(500)

$(document).on "click", "#answer-btn", ->
  $(this).parent().parent().children('#replies').slideToggle('show')
  if $(this).html() == '<i class="fa fa-plus"></i>' then $(this).html('<i class="fa fa-minus"></i>') else $(this).html('<i class="fa fa-plus"></i>')



$(document).on 'click', ".tab",(e) ->
  e.preventDefault()
  $(".tab").removeClass 'tabActive'
  $(this).addClass 'tabActive'

$(document).on "click", ".com-tab", ->
  $('.comments-content').show(500)
  $('.badge-content').hide()
  $('.activity-content').hide()
  return false



$(document).on "click", ".act-tab", ->
  $(this).addClass 'tabActive'
  $('.activity-content').show(500)
  $('.badge-content').hide()
  $('.comments-content').hide()
  return false


$(document).on "click", ".badge-tab", ->
  $(this).addClass 'tabActive'
  $('.badge-content').show(500)
  $('.activity-content').hide()
  $('.comments-content').hide()
  return false



# Archivement badges show
$(document).on "click", ".arch-toggle", ->
  $('.arch').slideToggle 'slow'
  return

$(document).on "click", ".fed", ->
  $('.fed-toggle').slideToggle 'slow'
  return


$(document).on "click", ".add-mod-btn2", ->
  $('.feeed').slideToggle 'slow'
  return
# MOBIL MENY JS


btn = false

$(document).on "click", ".mobile-menu-btn", ->
  if btn
    $('.mobile-menu-btn').animate { left: '0' }, 500
    $('.sidebar').animate { width: 'toggle' }, 500
    btn = false
  else
    $('.mobile-menu-btn').animate { left: '85%' }, 500
    $('.sidebar').animate { width: 'toggle' }, 500
    btn = true
    return
  return
