#= require lodash
#= require react
#= require heracles/admin/filtrex
#= require heracles/admin/components/available_fields

#= require_self

# Require the various fields as dependants
#= require heracles/admin/fields/fields_nav
#= require heracles/admin/fields/fields_tags
#= require heracles/admin/fields/field_array
#= require heracles/admin/fields/field_array__checkbox
#= require heracles/admin/fields/field_boolean
#= require heracles/admin/fields/field_content
#= require heracles/admin/fields/field_float
#= require heracles/admin/fields/field_integer
#= require heracles/admin/fields/field_text
#= require heracles/admin/fields/field_text__code
#= require heracles/admin/fields/field_text__radio
#= require heracles/admin/fields/field_text__select
#= require heracles/admin/fields/field_date_time
#= require heracles/admin/fields/field_associated_page
#= require heracles/admin/fields/field_associated_pages
#= require heracles/admin/fields/field_asset
#= require heracles/admin/fields/field_assets
#= require heracles/admin/fields/field_info
#= require heracles/admin/fields/field_unsupported

###* @jsx React.DOM ###

Fields = React.createClass
  getInitialState: ->
    fields: @_getFields() || []
    staleFields: @_getStaleFields() || []
    debug: false
  updateField: (field_name, fieldData) ->
    fieldsCopy = JSON.parse(JSON.stringify(@state.fields))
    fieldIndex = _.findIndex fieldsCopy, field_name: field_name
    fieldsCopy[fieldIndex] = fieldData unless fieldIndex is -1
    staleFieldsCopy = JSON.parse(JSON.stringify(@state.staleFields))
    staleFieldIndex = _.findIndex staleFieldsCopy, field_name: field_name
    staleFieldsCopy[staleFieldIndex] = fieldData unless staleFieldIndex is -1
    if @_fieldsHaveChanged(fieldsCopy) || @_staleFieldsHaveChanged(staleFieldsCopy) then $(document).trigger "field:changed"
    @setState
      fields: fieldsCopy
      staleFields: staleFieldsCopy
  removeConfig: (fields) ->
    _.map fields, (field) ->
      newField = _.extend {}, field
      delete newField.field_config
      newField
  toggleDebug: (e) ->
    @setState debug: @refs.showDebug.getDOMNode().checked
  formatDebug: ->
    if HeraclesAdmin.superAdmin
      debugClassName = React.addons.classSet
        "fields-debug": true
        "fields-debug--hidden": !@state.debug
      debugFields = if @state.debug then `<pre className="fields-debug__data">{JSON.stringify(this.state.fields, null, 2)}</pre>` else ""
      return `<div className={debugClassName}>
        <div className="field-checkbox">
          <input className="field-checkbox-input" type="checkbox" ref="showDebug" id="fields-debug__checkbox" onChange={this.toggleDebug}/>
          <label className="field-checkbox-label" htmlFor="fields-debug__checkbox">Show field data?</label>
        </div>
        {debugFields}
      </div>`
    else
      ""
  render: ->
    fieldNodes = @_formatFieldNodes(@state.fields, false)
    staleFieldsNodes = @_formatFieldNodes(@state.staleFields, true)
    destroy_all = _.every @state.staleFields, { '_destroy': true }
    message = if window.HeraclesAdmin.superAdmin
      "These fields have been removed from the page definition, their data will remain until you delete them and save the page."
    else
      "These fields have been removed from the page definition, their data will remain until your site developer deletes them."
    if staleFieldsNodes.length > 0 && !destroy_all
      staleFields = `<div className="fields-stale">
        <div className="field-divider" />
        <h2 className="fields-stale__header">Orphaned fields</h2>
        <p className="copy">{message}</p>
        {staleFieldsNodes}
      </div>`
    else
      staleFields = ""
    fields = @state.fields.concat @state.staleFields
    `<div className="fields">
      <input type="hidden" name={this.props.fieldsDataName} value={JSON.stringify(this.removeConfig(fields))}/>
      {fieldNodes}
      {this.formatDebug()}
      {staleFields}
    </div>`
  _formatFieldNodes: (fields, isStale) ->
    _this = @
    columnCounter = 0
    fieldNodes = []
    rowNodes = []
    fieldData = @_gatherFieldData(fields)
    _.each fields, (field, index) ->
      # Calc first column in row
      columns = field.field_config.field_editor_columns || 12
      newRow = false
      columnCounter = columnCounter + columns
      # Display by default
      display = true
      if columnCounter > 12 then columnCounter = columns
      if columnCounter is 0 or columns is 12
        newRow = true
      propData =
        field: field
        newRow: newRow
        key: field.field_name
        updateField: _this.updateField

      # Retrieve the components from the `availableFields`
      if newRow
        fieldNodes.push `<div className="fields-row">{rowNodes}</div>`
        rowNodes = []
      # Evaulate whether or not field should display
      if field.field_config.field_display_if?
        # Compile the display_if expression with filtrex
        filter = compileExpression(field.field_config.field_display_if)
        display = filter(fieldData)
      if display && (!field._destroy || field._destroy == undefined)
        # If it's a stale field, add the delete button
        if isStale && window.HeraclesAdmin.superAdmin
          rowNodes.push `<div className="fields-stale__actions"><a href="#" className="fields-stale__delete" onClick={_this._handleDelete.bind(this, field)}><i className="fa fa-trash">&nbsp;</i>Remove</a></div>`
        if field.field_config.field_supported
          # Add field to the row
          rowNodes.push HeraclesAdmin.availableFields.get field.field_config.field_editor_type, propData
        else
          # Use the unsupported field component
          rowNodes.push HeraclesAdmin.availableFields.get "unsupported", propData
        if index is fields.length - 1
          fieldNodes.push `<div className="fields-row">{rowNodes}</div>`
    return fieldNodes
  # Create a singular object with field names as keys
  _gatherFieldData: (fields) ->
    data = {}
    _.each fields, (field) ->
      data[field.field_name] = field
    return data
  _getFields: ->
    fields = []
    _.each @props.fields, (field, index) ->
      if !field.field_config.field_stale
        fields.push(field)
    return fields
  _getStaleFields: ->
    staleFields = []
    _.each @props.fields, (field, index) ->
      if field.field_config.field_stale
        staleFields.push(field)
    return staleFields
  _handleDelete: (field, e) ->
    e.preventDefault()
    staleFieldsCopy = JSON.parse(JSON.stringify(@state.staleFields))
    fieldIndex = _.findIndex staleFieldsCopy, { 'field_name': field.field_name }
    if fieldIndex >= 0
      staleFieldsCopy[fieldIndex]._destroy = true
      if @_staleFieldsHaveChanged(staleFieldsCopy) then $(document).trigger "field:changed"
      @setState
        staleFields: staleFieldsCopy
  _staleFieldsHaveChanged: (newStaleFields) ->
    JSON.stringify(newStaleFields) != JSON.stringify(@state.staleFields)
  _fieldsHaveChanged: (newFields) ->
    JSON.stringify(newFields) != JSON.stringify(@state.fields)


window.FieldMixin =
  # Constructs a className string for the entire field. Sets up the columnar
  # layout
  displayClassName: (fieldClassName) ->
    # Would love to use classSet here but it doesn't let you have evaled property names
    columns = @props.field.field_config.field_editor_columns || 12
    newRow = if @props.newRow then "field-columns--new-row" else ""
    errors = unless _.isEmpty(@props.field.errors) then "field--has-errors" else ""
    "field field-columns--#{columns} #{fieldClassName} #{newRow} #{errors}"
  # Constructs a className string for modifying the size of <input> or <textarea> (mostly)
  inputSizeClassName: ->
    if @props.field.field_config.field_editor_input_size? then "field-size--#{@props.field.field_config.field_editor_input_size}" else ""
  cancelFormSubmit: (e) ->
    e.preventDefault()

# Register fields view
HeraclesAdmin.views.fieldsEditor = ($el, el) ->
  fieldsData = JSON.parse $el.find("input").val() || []
  # Render the FieldsNav
  React.renderComponent(
    FieldsNav(
      fields: fieldsData
    ), $('.form-nav')[0]
  )

  # Render tags
  tagsTarget = $('.form-body__tags')
  React.renderComponent FieldsTags(tags: tagsTarget.data('content')), tagsTarget[0]

  # Render the Fields
  React.renderComponent(
    Fields(
      fields: fieldsData
      fieldsDataName: $el.find("input").attr("name")
    ), el
  )
