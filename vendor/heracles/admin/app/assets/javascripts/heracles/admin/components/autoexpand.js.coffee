#= require jquery

"use strict"

class AutoExpand
  constructor: (@$el) ->
    @$el.on "focus keyup", => @expand()
    @expand()
  expand: ->
    @$el.css { height: "auto" }
    @$el.css { height: @$el.prop "scrollHeight" }

HeraclesAdmin.views.autoExpand = ($el) -> new AutoExpand $el
