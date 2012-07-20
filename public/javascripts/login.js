(function() {

  (function($) {
    var blank;
    blank = function(element) {
      return jQuery.trim($(element).val()) === "";
    };
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
        return setInterval((function() {
          return controlPlaceholderState({
            target: _this
          });
        }), 100);
      });
    };
  })(jQuery);

  $(function() {
    var $fields, $submitButton, debounce, measureAndCut;
    $fields = $("#email_field, #password_field");
    $submitButton = $("#submit_button");
    $("#login_form").submit(function() {
      var valid;
      valid = !$fields.blank();
      if (!valid) {
        alert("Please enter your email and password to log in.");
      }
      $submitButton.addClass("disabled").prop("disabled", true);
      return valid;
    });
    $submitButton.toggleClass("disabled", $fields.blank()).prop("disabled", $fields.blank());
    $fields.on("keyup keydown", function() {
      var disabled;
      disabled = $fields.blank() || !$fields.val().match(/.+\@.+\..+/);
      return $submitButton.toggleClass("disabled", disabled).prop("disabled", disabled);
    });
    if ("ontouchstart" in window) {
      scrollTo(0, 0);
    } else {
      $('#email_field').focus();
    }
    $fields.placeholder();
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
    measureAndCut = function() {
      return $('html').toggleClass('short_viewport', $(window).height() < 530);
    };
    measureAndCut();
    return $(window).on('resize', debounce(measureAndCut, 500));
  });

}).call(this);
