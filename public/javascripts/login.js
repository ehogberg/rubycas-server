(function() {
  var blank, debounce, every;

  blank = function(element) {
    return jQuery.trim($(element).val()) === "";
  };

  every = function(ms, f) {
    return setInterval(f, ms);
  };

  debounce = function(func, wait, immediate) {
    return function() {
      var args, context, later, timeout;
      context = this;
      args = arguments;
      later = function() {
        var timeout;
        timeout = null;
        if (!immediate) {
          return func.apply(context, args);
        }
      };
      if (immediate && !timeout) {
        func.apply(context, args);
      }
      clearTimeout(timeout);
      return timeout = setTimeout(later, wait);
    };
  };

  (function($) {
    $.fn.blank = function() {
      var element, elements, empty, _i, _len;
      elements = this.toArray();
      empty = false;
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        element = elements[_i];
        if (blank(element)) {
          empty = true;
          break;
        }
      }
      return empty;
    };
    return $.fn.placeholder = function() {
      var controlFieldFocus, controlPlaceholderState, makePlaceholderElement, placeholders;
      placeholders = {};
      controlPlaceholderState = function(e) {
        var $placeholder;
        $placeholder = placeholders[e.target.id];
        $placeholder.toggleClass("visible", blank(e.target));
        return setTimeout((function() {
          return $placeholder.toggleClass("visible", blank(e.target));
        }), 0);
      };
      controlFieldFocus = function(e) {
        return $(e.target).toggleClass("focus", e.type === "focus");
      };
      makePlaceholderElement = function() {
        var $placeholder, id;
        id = this.id;
        $placeholder = placeholders[id] = $(document.createElement("div"));
        $placeholder.text($("#" + id).attr("placeholder")).addClass("placeholder").toggleClass("visible", $("#" + id).blank()).click(function() {
          return $("#" + id).focus();
        });
        return $("#" + id).attr("placeholder", "").before($placeholder);
      };
      return this.on("keyup keydown change", controlPlaceholderState).on("focus blur", controlFieldFocus).each(makePlaceholderElement).each(function(i) {
        var _this = this;
        return every(100, function() {
          return controlPlaceholderState({
            target: _this
          });
        });
      });
    };
  })(jQuery);

  $(function() {
    var $email, $fields, $password, $submitButton, controlButtonState, measureAndCut;
    $email = $("#email_field");
    $password = $("#password_field");
    $fields = $("#email_field, #password_field");
    $submitButton = $("#login-submit");
    controlButtonState = function() {
      var disabled;
      disabled = $fields.blank() || !$email.val().match(/.+\@.+\..+/);
      return $submitButton.toggleClass("disabled", disabled);
    };
    measureAndCut = function() {
      return $('html').toggleClass('short_viewport', $(window).height() < 530);
    };
    $("#login_form").submit(function() {
      var valid;
      valid = !$fields.blank();
      if (!valid) {
        alert("Please enter your email and password to log in.");
      }
      $submitButton.addClass("disabled");
      return valid;
    });
    $fields.on("keyup keydown", controlButtonState);
    controlButtonState();
    every(100, controlButtonState);
    $fields.placeholder();
    measureAndCut();
    $(window).on('resize', debounce(measureAndCut, 500));
    if ("ontouchstart" in window) {
      return scrollTo(0, 0);
    } else {
      return $email.focus();
    }
  });

}).call(this);
