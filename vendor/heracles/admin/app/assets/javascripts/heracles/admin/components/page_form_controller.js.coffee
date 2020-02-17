#= require jquery
#= require react
#= require heracles/admin/components/available_insertables
#= require heracles/admin/fields/fields

"use strict"

#
# Main controller for the page form
# Handles any overarching bits and pieces
#

class PageFormController
  constructor: (@$el) ->
    @$doc = $(document)
    @$el.on "click", "[data-page-preview]", @submitPreview
    # Running sheet
    @watchSlug()
    @setupInsertables()
    @setupChangePageType()
    @focusTitleInput()

  setupInsertables: ->
    insertableEditor = new InsertableEditor()

  # Bind the title and the slug together unless the slug is different from the
  # title, like when it’s been manually changed by the user (or the system)
  watchSlug: ->
    $title = @$el.find ".page-form__title"
    $slug  = @$el.find ".page-path__slug"
    previousTitle = $title.val()
    @$el.on "keyup change", ".page-form__title", ->
      newTitle = HeraclesAdmin.helpers.slugify $title.val()
      if HeraclesAdmin.helpers.slugify(previousTitle) is $slug.val()
        $slug.val(newTitle).trigger "change"
      previousTitle = newTitle

  submitPreview: (e) =>
    e.preventDefault()
    $button     = $(e.target)
    previewData = $button.data("page-preview")
    $form       = @$el.find(".edit-page-form").clone()

    $form
      .append $("<input type='hidden' name='site_preview_token'>").val(previewData.token)
      .attr "action", previewData.url
      .attr "target", "_blank"
    $form.find("input[name=_method]").val("post")
    $(document.body).append($form)
    $form.trigger "submit"

  setupChangePageType: ->
    $toggle = @$el.find ".change-page-type__toggle"
    $toggle.on "click", @toggleChangePageType

  toggleChangePageType: (e) =>
    e.preventDefault()
    @$el.find(".change-page-type").toggleClass("change-page-type--open")

  focusTitleInput: ->
    @$el.find(".page-form__title").focus()

HeraclesAdmin.views.pageFormController = ($el) -> new PageFormController $el
