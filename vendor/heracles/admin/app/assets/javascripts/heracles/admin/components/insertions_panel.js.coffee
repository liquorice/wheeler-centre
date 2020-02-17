#= require jquery

"use strict"

HeraclesAdmin.views.insertionsPanel = ($el) ->
  $el.on "click", ".form-insertions-toggle", (e) ->
    e.preventDefault()
    $el.toggleClass "form-insertions--show"
