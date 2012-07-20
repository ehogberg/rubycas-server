(($)->

  # Add a 'blank' helper that checks if any fields are empty
  blank = (element)->
    jQuery.trim($(element).val()) is ""

  # Make a jQuery plugin that tests for any blank fields
  $.fn.blank = ->
    elements = @toArray()
    empty = false
    for element in elements
      if blank element
        empty = true
        break
    empty

  # Add a 'placeholder' plugin that normalizes the behavior across browsers.
  # It assumes that the fields have a unique ID and styles are provided
  # somewhere else.
  $.fn.placeholder = ->

    # Should this be centralized somewhere?
    placeholders = {}

    controlPlaceholderState = (e) ->
      $placeholder = placeholders[e.target.id]
      $placeholder.toggleClass "visible", blank e.target
      setTimeout (->
        $placeholder.toggleClass "visible", blank e.target
      ), 0

    controlFieldFocus = (e) ->
      $(e.target).toggleClass "focus", e.type is "focus"

    makePlaceholderElement = ->
      id = @id
      $placeholder = placeholders[id] = $ document.createElement "div"
      
      # Decorate placeholder element
      $placeholder
        .text($("##{id}").attr("placeholder"))
        .addClass("placeholder")
        .toggleClass("visible", $("##{id}").blank())
        .click -> $("##{id}").focus()

      # Insert placeholder element into DOM
      $("##{id}").attr("placeholder", "").before $placeholder


    @on("keyup keydown change", controlPlaceholderState)
    .on("focus blur", controlFieldFocus)
    .each(makePlaceholderElement)

    # In order to react to browsers autocompleting or autofilling
    # We have to poll for the change
    .each((i)->
      setInterval((=>
        controlPlaceholderState { target: @ }
      ), 100)
    )


)(jQuery)

$ ->
  $fields = $ "#email_field, #password_field"
  $submitButton = $ "#submit_button"
  $("#login_form").submit ->
    valid = not $fields.blank()
    alert "Please enter your email and password to log in." unless valid
    $submitButton.addClass("disabled").prop("disabled", true)
    valid

  $submitButton
    .toggleClass("disabled", $fields.blank())
    .prop("disabled", $fields.blank())

  $fields.on "keyup keydown", ->
    disabled = $fields.blank() or !$fields.val().match(/.+\@.+\..+/)
    $submitButton
      .toggleClass("disabled", disabled)
      .prop("disabled", disabled)


  if "ontouchstart" of window
    scrollTo 0, 0
  else
    $('#email_field').focus()


  # Use the placeholder plugin
  $fields.placeholder()
  

  # Ripped from Underscore
  debounce = (func, wait, immediate) ->
    ->
      context = this
      args    = arguments
      later   = ->
        timeout = null
        unless immediate
          func.apply context, args

      if immediate and not timeout
        func.apply context, args

      clearTimeout timeout
      timeout = setTimeout later, wait

  # Manage the footer
  measureAndCut = ->
    $('html').toggleClass 'short_viewport', ($(window).height() < 530)

  measureAndCut()

  $(window).on 'resize', debounce measureAndCut, 500


