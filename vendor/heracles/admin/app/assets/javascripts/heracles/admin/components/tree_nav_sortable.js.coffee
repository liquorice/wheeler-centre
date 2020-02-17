#= require jquery
#= require heracles/admin/utils/jquery-ui

"use strict"

class TreeNavSortable
  constructor: (@$el) ->
    @$doc = $(document)
    @bind_events()

  bind_events: ->
    # Use event capturing to create the sortables on demand
    document.addEventListener("mousedown", (e) =>
      # Only bind the event to the 'move' icon
      return unless $(e.target).parent().is ".tree-nav__list-move"
      @init_sortable $(e.target).closest(".tree-nav__children")
    , true)

  init_sortable: ($el) ->
    $el.sortable
      axis: "y"
      items: "> .tree-nav__list-item:not(.tree-nav__list-item--home)"
      containment: ".tree-nav__list"
      update: @update
      start: @start_dragging
      stop: @stop_dragging

  start_dragging: (e, $ui) ->
    # Hide any children while dragging
    $(".tree-nav__children", @).each () ->
      if height = $(@).siblings(".tree-nav__list-item-wrapper").height()
        $(@).parent().css { overflow: "hidden", height: height+"px" }
    # Reset the height of the placeholder
    $ui.placeholder.height $ui.helper.height()
    $(@).sortable "refreshPositions"

  stop_dragging: (e, $ui) ->
    # Restore heights
    $(".tree-nav__list-item", @).css { height: "auto" }
    $(@).sortable "destroy"

  update: (e, $ui) ->
    $.ajax
      type: "PATCH"
      url: $ui.item.data("update-url")
      dataType: "json"
      contentType: "application/json"
      data: JSON.stringify(page: { page_order_position: $ui.item.index() })

HeraclesAdmin.views.treeNavSortable = ($el) -> new TreeNavSortable $el
