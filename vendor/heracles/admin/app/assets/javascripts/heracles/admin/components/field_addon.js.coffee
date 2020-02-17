#= require jquery

"use strict"

class window.FieldAddon
  constructor: (@$el, trigger = "focus") ->
    input = @$el.find('.field-addon-input')
    @$el.on "click", '.field-addon-text', ->
      if typeof trigger is "string"
        input.trigger trigger
      else
        # Call with this == input
        trigger.call(input)

HeraclesAdmin.views.fieldAddon = ($el) -> new FieldAddon $el
