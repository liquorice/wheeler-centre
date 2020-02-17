#= require jquery
#= require react

#
# Simple class for registering insertables in a persistant store.
#
# Get a list of the register insertables:
#
#    HeraclesAdmin.availableInsertables.list()
#
# Register an insertable:
#
#    HeraclesAdmin.availableInsertables.add
#      type:  "image"
#      label: "Image"
#      icon: "picture-o" # Optional
#      displayTemplate: "<div insertable="image" contenteditable="false" ...></div>"
#
#
class AvailableInsertables
  constructor: ->
    @insertables = []
  add: (insertable) -> @insertables.push(insertable)
  get: (type) ->
    for insertable in @insertables
      if insertable.type is type then return insertable
  list: -> @insertables


# FIXME This is attached no matter what which is OK, but kinda lame.
# Attach the instance to the window
window.HeraclesAdmin.availableInsertables = new AvailableInsertables()

class window.InsertableEditor
  constructor: ->
    @$doc = $(document)
    @classPrefix = "field-content-editor__insertable"
    @container = $("<div class='#{@classPrefix}'>").appendTo '[data-view-page-form-controller]'
    # Events
    @$doc.on "insertable:edit", @openEditor
    @$doc.on "insertable:close cover:close", @closeEditor

  # Listen for `insertable:edit` event and activate the editor
  openEditor: (e, type, value, size, handleValueChange, isGalleryAsset, onValueUpdate) =>
    @size = size
    @renderTemplate type, value, handleValueChange, isGalleryAsset, onValueUpdate
    @container.css { "width": "#{@size}%" }
    setTimeout(=>
      @container.addClass "#{@classPrefix}--active"
    , 0)

  renderTemplate: (type, value, handleValueChange, isGalleryAsset, onValueUpdate) ->
    insertable = HeraclesAdmin.availableInsertables.get type
    container = @container[0]
    isGalleryAsset = isGalleryAsset || null
    React.renderComponent(
      insertable.edit(
        container: container
        value: value
        handleValueChange: handleValueChange
        isGalleryAsset: isGalleryAsset
        onValueUpdate: onValueUpdate
      ), container
    )

  closeEditor: =>
    # Clear the style out
    @container.removeAttr "style"
    @container.removeClass "#{@classPrefix}--active"


# Mixins for Insertable components
window.InsertableDisplayMixin =
  getInitialState: ->
    size:  @props.size || "30"
    value: @props.value
  componentDidMount: ->
    @$doc = $(document)
    @$doc.on "cover:close", => setTimeout(@removeIfEmpty, 0)
    if @isEmpty(@props.value) then @editValue()

  updateContainerValue: (newValue) ->
    $(@props.container).attr "value", JSON.stringify newValue

  removeIfEmpty: (value) ->
    value = value || @state.value
    if @isEmpty(value) then @remove()

  isEmpty: (value) ->
    value = value || @state.value
    _.isEmpty value

  # Called by the equivalent `Edit` component
  handleValueChange: (newValue) ->
    @setState value: newValue
    @updateContainerValue(newValue)
    @removeIfEmpty(newValue)

  # Trigger event on the document
  editValue: ->
    @$doc.trigger "insertable:edit", [
      @props.type,
      @state.value,
      @state.size,
      @handleValueChange,
      @state.isGalleryAsset,
      @onValueUpdate
    ]

  # Remove the insertable
  remove: ->
    React.unmountComponentAtNode @props.container
    $(@props.container).remove()

window.InsertableEditMixin =
  getInitialState: ->
    return {
      value: @props.value
    }
  componentDidMount: ->
    @$doc = $(document)
    @$doc.on "cover:close", => @removeComponent()
  removeComponent: ->
    # Destroy self
    setTimeout(=>
      React.unmountComponentAtNode @props.container
    , 300)
  onSubmit: (e) ->
    e.preventDefault()
    @$doc.trigger("insertable:close")
    # Send the data back
    @props.handleValueChange @state.value
    # if this.onValueUpdate(), pass is the value of the asset
    if @props.onValueUpdate then @props.onValueUpdate(@state.value)
    @removeComponent()
