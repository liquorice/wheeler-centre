#= require jquery

"use strict"

class SaveStateTracker
  constructor: (@$el) ->
    @callCount = 0
    # You need to add the `data-check-save-state` attribute to anything you
    # want to check state on. Alternatively you can trigger manually with
    # the `field:changed` event on the document.
    @$el.on 'change', '[data-check-save-state]', @trackPageExit
    @$el.on 'submit', @cancelTracking
    $(document).on "field:changed", @trackPageExit

  trackPageExit: =>
    # Only need to call this once
    @callCount = @callCount + 1
    return if @callCount > 1
    # Highlight the unsaved state
    @$el.addClass "unsaved-changes"
    # Track any main events which could involve leaving the page
    $(window).on "beforeunload", ->
      "There are unsaved changes on this page. Are you sure you want to leave?"
    $('body').off 'click.trackPageExit'
    $('body').on "click.trackPageExit", "a:not([href=''],[href^='#'])", (e) ->
      unless e.metaKey
        confirm "There are unsaved changes on this page. Are you sure you want to leave?"

  cancelTracking: =>
    # Unbind all events
    $(window).off "beforeunload"
    $('body').off 'click.trackPageExit'

HeraclesAdmin.views.saveStateTracker = ($el) -> new SaveStateTracker $el
