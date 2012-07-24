# Add a 'blank' helper that checks if any fields are empty
blank = (element)->
  jQuery.trim($(element).val()) is ""

# setInterval helper
every = (ms, f)-> setInterval f, ms

# Ripped from Underscore
# Prevents a function from being called more frequently than a given interval
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


# Add a simple placeholder jQuery plugin
(($)->

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
      every 100, =>
        controlPlaceholderState { target: @ }
    )


)(jQuery)

# On DOM Ready
$ ->
  # Get references to DOM elements
  $email        = $ "#email_field"
  $password     = $ "#password_field"
  $fields       = $ "#email_field, #password_field"
  $submitButton = $ "#login-submit"

  # A callback that controls the appearance of the submit button
  controlButtonState = ->
    disabled = $fields.blank() or !$email.val().match(/.+\@.+\..+/)
    $submitButton.toggleClass("disabled", disabled)

  # Manage the footer
  measureAndCut = ->
    $('html').toggleClass 'short_viewport', ($(window).height() < 530)

  # Validate form on submit
  $("#login_form").submit ->
    valid = not $fields.blank()
    alert "Please enter your email and password to log in." unless valid
    $submitButton.addClass("disabled")
    valid

  # Attach button callback
  $fields.on "keyup keydown", controlButtonState
  controlButtonState()
  every 100, controlButtonState

  # Use the placeholder plugin
  $fields.placeholder()

  # When the window resizes, set a class name on the html element
  measureAndCut()
  $(window).on 'resize', debounce measureAndCut, 500

  # Hide mobile browser's chrome or focus on first email field
  if "ontouchstart" of window
    scrollTo 0, 0
  else
    $email.focus()


