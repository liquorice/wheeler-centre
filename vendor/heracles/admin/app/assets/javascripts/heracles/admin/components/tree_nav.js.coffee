#= require jquery

"use strict"

class TreeNav
  constructor: (@$el) ->
    @$doc = $(document)
    $('.tree-nav__open-nav', @$el).on 'click', @openTree
    $('.tree-nav__close-nav', @$el).on 'click', @closeTree
    @$doc.bind "cover:close", @closeTree

  openTree: (e) =>
    e?.preventDefault()
    @$doc.trigger 'treeNav:open', [25]

  closeTree: (e) =>
    e?.preventDefault()
    @$doc.trigger 'treeNav:close'

HeraclesAdmin.views.treeNav = ($el) -> new TreeNav $el
