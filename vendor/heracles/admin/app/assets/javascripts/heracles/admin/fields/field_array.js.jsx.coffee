#= require lodash
#= require react
#= require heracles/admin/utils/jquery-ui

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldArray = React.createClass
  mixins: [FieldMixin]
  propTypes:
    values: React.PropTypes.array
  getInitialState: ->
    editingIndex: null
    field: @props.field
    values: @props.values || []
  componentDidMount: ->
    @$el = $(@getDOMNode())
    @setupSortable()
  setupSortable: ->
    @$el.find(".field-array__items").sortable
      axis: "y"
      items: ".field-array__item"
      update: @onSortableUpdate
  onSortableUpdate: (e, $ui) ->
    originalPosition = $ui.item.data("position")
    newPosition = $ui.item.index()
    values = @state.values.slice(0)
    removed = values.splice(originalPosition, 1)
    values.splice(newPosition, 0, removed[0])
    @setState values: values
    @handleChange values
  handleChange: (values) ->
    # Update the parent fields
    newField = _.extend {}, @state.field, values: values
    @props.updateField @state.field.field_name, newField
  addItem: (e) ->
    e.preventDefault()
    newItemInput = @refs.newItemInput.getDOMNode()
    userInput = newItemInput.value
    if userInput? and _.isEmpty(userInput) != true
      newValues = @state.values.slice(0)
      newValues.push userInput
      @setState values: newValues
      @handleChange(newValues)
      # Clean up
      newItemInput.value = ""
      newItemInput.focus()
  removeItem: (index, e) ->
    e.preventDefault()
    newValues = @state.values.slice(0)
    newValues.splice(index, 1)
    @setState values: newValues
    @handleChange(newValues)
  editItem: (index, e) ->
    e.preventDefault()
    @setState editingIndex: index
  saveItem: (index, e) ->
    e.preventDefault()
    @state.values[index] = @refs["editingItem#{index}"].getDOMNode().value
    @setState
      editingIndex: null
      values: @state.values
    @handleChange @state.values
  cancelEdit: (e) ->
    e.preventDefault()
    @setState editingIndex: null
  buildItemList: ->
    _this = @
    if @state.values.length > 0
      items = _.map @state.values, (item, index) ->
        editing = _this.state.editingIndex == index
        className = React.addons.classSet
          "field-array__item": true
          "field-array__item--editing": editing
        key = "#{item}-#{index}"
        output = if editing
          ref = "editingItem#{index}"
          `<div className="field-addon">
            <input type="text" ref={ref} onKeyDown={_this._onSaveItemKeyDown.bind(this, index)} className="field-small field-text-input field-addon-input" defaultValue={item}/>
            <button onClick={_this.saveItem.bind(this, index)} className="field-addon-button field-addon-button--last button button--small button--soft">Save</button>
            <span className="field-array__cancel">
              or
              <a href="#cancel" className="field-array__cancel-button" onClick={_this.cancelEdit}>cancel</a>
            </span>
          </div>`
        else
          `<div>
            <div className="button-group field-array__item-buttons">
              <button className="button button--small insertable-display__edit button button--soft" onClick={_this.editItem.bind(_this, index)}>
                Edit
              </button>
              <button className="button button--small insertable-display__remove button button--soft" onClick={_this.removeItem.bind(_this, index)}>
                <i className="fa fa-times"/>
              </button>
            </div>
            <div className="field-array__item-label">{item}</div>
          </div>`
        `<li className={className} data-position={index} key={key}>
          {output}
        </li>`
      `<ul className="field-array__items">
        {items}
      </ul>`
    else
      ""
  formatFallback: ->
    if @state.field.field_config.field_fallback?.values?
      items = _.map @state.field.field_config.field_fallback?.values, (value) ->
        `<li>{value}</li>`
      `<ul>{items}</ul>`

  render: ->
    itemList = @buildItemList()
    placeholder = if @state.values.length > 0 then "Add another item …" else "There are no items yet. Add the first?"
    return `<div className={this.displayClassName("field-array")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main field-main--border-top">
          {itemList}
          <div className="field-addon field-array__add-items">
            <input onKeyDown={this._onAddItemKeyDown} type="text" ref="newItemInput" className="field-small field-text-input field-addon-input" placeholder={placeholder}/>
            <button onClick={this.addItem} type="submit" className="field-addon-button button button--small button--soft">Add item</button>
          </div>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`

  _onSaveItemKeyDown: (index, e) ->
    # Enter
    if e.keyCode is 13 then @saveItem(index, e)

  _onAddItemKeyDown: (e) ->
    # Enter
    if e.keyCode is 13 then @addItem(e)

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "array"
  formatProps: (data) ->
    key: data.key
    newRow: data.newRow
    updateField: data.updateField
    field: data.field
    values: data.field.values
  component: FieldArray
