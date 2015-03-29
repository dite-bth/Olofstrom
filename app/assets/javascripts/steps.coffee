# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Gets all checkboxes for the substep check if done part
getAllDone = ->
  return document.getElementsByClassName("donebox")

getSubSteps = ->
  raw = document.getElementsByClassName("donebox")
  substeps = {}
  for x,y in raw
    id = $(x).attr("id")
    if $(x).is(":checked")
      substeps[id] = "done"
      console.log "Checked is true: " + JSON.stringify(substeps)
    else
      substeps[id] = "notdone"
      console.log "Checked is false: " + JSON.stringify(substeps)
  return substeps
#$(document).on('page:before-change', getSubSteps)
$(document).on('page:before-unload', getSubSteps)
$(document).on('page:fetch', getSubSteps)
$(document).on('page:receive', getSubSteps)
$(document).on('page:change', getSubSteps)
$(document).ready(getSubSteps)


#returns if all the checkboxes for the substep check is checked or not (true/false)
#This is because we want to see if the entire step is done
getAllChecked = ->
  all = getAllDone()
  notDone = []
  for x,y in all
    if $(x).is(":checked")
      console.log notDone
    else
      notDone.push(x)

  if notDone.present()
    return false
  else
    return true

getSubStep = (thiss) ->
  substep = {}
  substep[$(thiss).attr("id")] = if $(thiss).is(":checked") then "done" else "notdone"
  return substep
#What happens when you check one of the substep checkboxes?
#This will call the function to see if every box is checked after
#Should send the updates to the local json object and then update DB with the values



ready = ->
  if gon.completion
    substeps = $.parseJSON(gon.completion)
    if substeps
      substepsx = substeps[gon.catname][gon.stepname]
      for x,y of substepsx
        if y == "done"
          $("#"+x).prop("checked", true)
          completed = $("#"+x).parent().parent() #FIXA FÖRIHELVETE FÖR QUIZ
          if completed.attr('class') == 'quiz-fix'
            completed_quiz = completed.parent()
            completed_quiz.removeClass('hidden-item')
          completed.removeClass('hidden-item')
        else if y == "notdone"
          $("#"+x).prop("checked", false)
#$(document).on('page:before-change', ready)
$(document).on('page:before-unload', ready)
$(document).on('page:fetch', ready)
$(document).on('page:receive', ready)
$(document).on('page:change', ready)
$(document).ready(ready)

$(document).on "click", ".donebox", ->
  substeps = getSubStep(this)
  substep = $(this).parent().parent()
  if substep.attr('class') == 'quiz-fix'
    substep = $(this).parent().parent().parent()
    #console.log substep
    substep_attr = substep.attr('id') #div id för substep
    substep_s = substep_attr.split('_')[0]+('_') #strängen step_ för substep
    substep_id = substep_attr.split('_')[1] #id som sträng för substep
    substep_id_int = parseInt(substep_id) #gör om id sträng till int
    substep_id_next = substep_id_int+1 #plus ett för att kunna remova hidden class för nästa substep
    next_substep_s = String(substep_s)+(substep_id_next) #Strängen för att leta upp rätt riv
    next_substep_div = $(this).parent().parent().parent().parent().children('#'+next_substep_s) #Här är rätt div
    #console.log next_substep_div
  else
    substep = $(this).parent().parent()
    #console.log substep
    substep_attr = substep.attr('id') #div id för substep
    substep_s = substep_attr.split('_')[0]+('_') #strängen step_ för substep
    substep_id = substep_attr.split('_')[1] #id som sträng för substep
    substep_id_int = parseInt(substep_id) #gör om id sträng till int
    substep_id_next = substep_id_int+1 #plus ett för att kunna remova hidden class för nästa substep
    next_substep_s = String(substep_s)+(substep_id_next) #Strängen för att leta upp rätt riv
    next_substep_div = $(this).parent().parent().parent().children('#'+next_substep_s) #Här är rätt div
    #console.log next_substep_div

  #console.log next_substep_div
  #console.log next_substep_div
  next_substep_div.removeClass('hidden-item') #remove hidden class to show next substep
  if gon.admin == false
    $('html, body').animate({scrollTop:$(document).height()}, 1000)
  #console.log substep_s
  #console.log substep_id
  #console.log substep_id_next
  category_name = gon.catname
  step_name = gon.stepname
  completion = gon.completion
  #Update completion <<< Here
  #Update database <<< Here
  $.ajax(
    type: 'POST'
    url: '/steps/update_completion'
    dataType: 'json'
    data: { step: {name:category_name, step_name:step_name, substepsx: substeps } }
  )
    #Should be done through AjAX probably best way
    #LEts see what we can do.

  tese = getAllDone()
  if getAllChecked()
    $('#complete').show()
    getDialog()

    #Update completion for Step is done fully <<
    #Update database for Step is done fully <<<
    #Should be done through AJAX probably
  #for x,y in tese
  #  if $(x).is(":checked")
  #    console.log x + " is checked"
  #  else
  #    console.log x + " is not checked"
hideContinue = ->
  done = 0
  not_done = 0
  if gon.completion
    substeps = $.parseJSON(gon.completion)
    if substeps
      substepsx = substeps[gon.catname][gon.stepname]
      for x,y of substepsx
        if y == "done"
          done++
        else if y == "notdone"
          not_done++
      if done == 0 and not_done > 0
        $('#continue').hide()
      else if not_done == 0 and done > 0
        $('#continue').hide()
        $('#complete').show()

$(document).on('page:before-unload', hideContinue)
$(document).on('page:fetch', hideContinue)
$(document).on('page:receive', hideContinue)
$(document).on('page:change', hideContinue)
$(document).ready(hideContinue)


$(document).on "click", "#continue", ->
  substep_class = $(this).siblings('.hidden-item')
  next_substep = $(substep_class).first()
  next_substep.removeClass('hidden-item')
  $(this).hide()
  $('html, body').animate({scrollTop:$(document).height()}, 1000)

$(document).on "click", "#show_video", ->
  video = $(this).parent().find('#video_url')
  video.toggle('show')
  if $(this).html() == 'Visa mer' then $(this).html('Dölj') else $(this).html('Visa mer')


$(document).on "click", "#show_desc", ->
  desc = $(this).parent().find('#desc')
  desc.toggle('show')
  if $(this).html() == 'Visa mer' then $(this).html('Dölj') else $(this).html('Visa mer')


$(document).on "click", "#show_questions", ->
  questions = $(this).parent().find('#quiz_questions')
  questions.toggle('show')
  if $(this).html() == 'Visa mer' then $(this).html('Dölj') else $(this).html('Visa mer')


$(document).on "click", "#show_questions_form", ->
  $(this).siblings('#questions_formx').toggle('show')
  if $(this).html() == 'Lägg till frågor' then $(this).html('Dölj') else $(this).html('Lägg till frågor')


$(document).on "click", "#drop_down_menu", ->
  select = $(this).children()
  $(select).on 'change', ->
    #form = $(this).parent().siblings().find('#forms')
    $('.guide_form').hide()
    $('.assignment_form').hide()
    $('.video_form').hide()
    $('.quiz_form').hide()
    $("#"+select.val()).toggle('show ')
    $(this).off(select)
  $(this).off("#drop_down_menu")


  #When submit_quiz div is clicked, do the following
$(document).on "click", "#submit_quiz", (e) ->
  #Gets the quiz id for later use
  qid = getQuestions(this)

  #console.log qid
  #Create a jquery object for the specific quiz div, select the quiz
  quiz = $("#quiz_"+qid)
  #Setup some variables to be used later
  window.qn = null
  window.checked = null
  wrong = []

  #Select questions inside the quiz
  quizchild = quiz.children() #Gets all questions like so in an object, I THINK

  #Loop through the questions one at a time
  for z,y in quizchild
    #Iterate if id = submit_quiz
    if $(z).attr('id') == 'submit_quiz'
      break
    #Get children of a question
    question = $(z).children()

    #Loop through the options
    for u,i in question

      #Check if the id exists, so it ignores <br>
      if $(u).attr('id')?

        #Set the length of our option array
        window.qn = $(u).length
        #The correct answer to the question, modify later
        correct = null

        #Get children of options, used for getting each individual options params
        options = $(question).children()

        #Loop the options and check if they're correct, if it's wrong, push it to a variable 'wrong' for later use
        for d,i in options
          if $(d).attr("id")?
            child = $(d)
            if $(child).is(":checked")
              window.checked+=1
              if $(child).attr('id') == 'correct'
                correct = $(child).attr('id')
              else
                $(child).css("color", "red")
                wrong.push $(u).attr('id')

    #Check if 'wrong' has anything in it
    if wrong.present()
      for o,i in wrong
        $("#"+o+" h3").css('color', 'red')

        console.log o
        console.log "This quiz is wrong.. This is bad!"

      #If it hasn't, check if all boxes are filled, if they are, the quiz is correctly answered
    else if !wrong.present() && window.checked == window.qn + 1
      console.log "This quiz is correctly answered yes guys!!!!"
      $('.quiz_hide').show()
      #Else, not all boxes are checked
    else
      console.log "Not all boxes in this quiz checked!"

Array::present = ->
  @.length > 0

getQuestions = (thiss) ->
  fvalue = $(thiss).attr("quiz")
  return fvalue

shuffle = ->
  quizzes = $(document).find('.quiz')

  for x,y in quizzes.toArray()
    #console.log x
    questions = $(x).children()
    #console.log questions
    for z, b in questions.toArray()
      #console.log z
      random = $(z).children()

      #console.log random
      for i, r in random
        #console.log i
        #console.log r
        if $(i).attr('id')?
          #console.log i

          i.appendChild random[Math.random() * r | 0]
  return

window.onload = ->
  shuffle()

normalize = (name) ->
  return name.toLowerCase().replace(/['’]/gi, '').replace(/ /gi, '-').replace(/[àáâãäå]/gi, 'a').replace(/[ö]/gi, 'o')

getStepItems = (item) ->
  fvalue = $(item).attr("step_item")
  return fvalue


do (window) ->

  extend = (a, b) ->
    for key of b
      if b.hasOwnProperty(key)
        a[key] = b[key]
    a

  DialogFx = (el, options) ->
    @el = el
    @options = extend({}, @options)
    extend @options, options
    @ctrlClose = @el.querySelector('[data-dialog-close]')
    @isOpen = false
    @_initEvents()
    return

  'use strict'
  support = animations: Modernizr.cssanimations
  animEndEventNames =
    'WebkitAnimation': 'webkitAnimationEnd'
    'OAnimation': 'oAnimationEnd'
    'msAnimation': 'MSAnimationEnd'
    'animation': 'animationend'
  animEndEventName = animEndEventNames[Modernizr.prefixed('animation')]

  onEndAnimation = (el, callback) ->

    onEndCallbackFn = (ev) ->
      if support.animations
        if ev.target != this
          return
        @removeEventListener animEndEventName, onEndCallbackFn
      if callback and typeof callback == 'function'
        callback.call()
      return

    if support.animations
      el.addEventListener animEndEventName, onEndCallbackFn
    else
      onEndCallbackFn()
    return

  DialogFx::options =
    onOpenDialog: ->
      false
    onCloseDialog: ->
      false

  DialogFx::_initEvents = ->
    self = this
    # close action
    @ctrlClose.addEventListener 'click', @toggle.bind(this)
    # esc key closes dialog
    document.addEventListener 'keydown', (ev) ->
      keyCode = ev.keyCode or ev.which
      if keyCode == 27 and self.isOpen
        self.toggle()
      return
    @el.querySelector('.dialog__overlay').addEventListener 'click', @toggle.bind(this)
    return

  DialogFx::toggle = ->
    self = this
    if @isOpen
      classie.remove @el, 'dialog--open'
      classie.add self.el, 'dialog--close'
      onEndAnimation @el.querySelector('.dialog__content'), ->
        classie.remove self.el, 'dialog--close'
        return
      # callback on close
      @options.onCloseDialog this
    else
      classie.add @el, 'dialog--open'
      # callback on open
      @options.onOpenDialog this
    @isOpen = !@isOpen
    return

  # add to global namespace
  window.DialogFx = DialogFx
  return


getDialog = ->
  dlgtrigger = document.querySelector('[data-dialog]')
  somedialog = document.getElementById(dlgtrigger.getAttribute('data-dialog'))
  dlg = new DialogFx(somedialog)
  dlgtrigger.addEventListener 'click', dlg.toggle.bind(dlg)
  return
$(document).on('page:before-unload', getDialog)
$(document).on('page:fetch', getDialog)
$(document).on('page:receive', getDialog)
$(document).on('page:change', getDialog)
$(document).ready(getDialog)
