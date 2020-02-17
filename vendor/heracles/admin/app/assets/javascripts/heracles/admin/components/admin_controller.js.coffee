#= require jquery
#= require react
#= require nprogress

#= require heracles/admin/components/tree_nav
#= require heracles/admin/components/tree_nav_sortable
#= require heracles/admin/lightboxes/lightbox__page_type

"use strict"

#
# General controller for the admin area
# Handles any overarching bits and pieces
#

class AdminController
  constructor: (@$el) ->
    @$doc = $(document)
    @$body = $("body")
    @$cover = $(".admin-wrapper__cover") # Cover sits outside .admin-wrapper
    # Listen for various events to show/hide the cover
    @$doc.on "insertable:edit", @showCover
    @$doc.on "insertable:edit", (e, type, value, size, handleStateChange) =>
      @hideAdmin("left", size)
    @$doc.on "insertable:close", @hideCover
    @$doc.on "treeNav:open", (e, size) =>
      @$el.addClass('tree-nav--open')
    @$doc.on "treeNav:close", =>
      @hideCover()
    # Broadcast a cover:close event when clicked
    @$cover.on "click", =>
      @hideCover()
      @$doc.trigger "cover:close"

    @bindAnchorScroll()
    @bindProgressIndicator()

  showCover: =>
    @$cover.addClass "admin-wrapper__cover--show"
  hideCover: =>
    @$cover.removeClass "admin-wrapper__cover--show"
    @showAdmin()

  hideAdmin: (direction, size) =>
    if direction is "left" then size = "neg-#{size}"
    @$el.addClass("admin-wrapper__cover--move-#{size}")
  showAdmin: =>
    @$el.removeClass (index, css) ->
      ((css.match(/\badmin-wrapper__cover--move-\S+/g) || []).join " ") + " tree-nav--open"

  bindAnchorScroll: ->
    @$doc.on "click", "[href^='#']", (e) =>
      $el = $(e.currentTarget)
      target = $("#{$el.attr("href")}")
      if target.length > 0
        e.preventDefault()
        targetY = target.offset().top - 20
        speed = Math.abs(targetY - @$doc.scrollTop())
        speed = if speed > 400
          400
        else if speed < 200
          200
        else
          speed
        @$body.animate({
          scrollTop: targetY
          specialEasing:
            scrollTop: "easeInOut"
        }, speed)

  bindProgressIndicator: ->
    @$doc.on 'page:fetch', NProgress.start
    @$doc.on 'page:change', NProgress.done
    @$doc.on 'page:restore', NProgress.remove

HeraclesAdmin.views.adminController = ($el) -> new AdminController $el
