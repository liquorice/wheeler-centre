#= require jquery

"use strict"

# Appends a class to the element passed by `data-activate-preview` attribute
class ActivatePreview
  constructor: (@$el, el, props) ->
    @class = props
    # if @class?
    @$el.on "mouseover touchstart", @startPreview
    @$el.on 'touchmove touchend mouseout', @endPreview
  startPreview = (e) =>
    e.preventDefault()
    @$el.addClass @class
  endPreview = => @$el.removeClass @class

HeraclesAdmin.views.activatePreview = ($el, el, props) -> new ActivatePreview $el, el, props
