#= require lodash
#= require react

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldArrayCheckbox = React.createClass
  mixins: [FieldMixin]
  propTypes: {
    values: React.PropTypes.array
  }
  getInitialState: ->
    # Make sure we have values for each option
    defaultValues = _.map @props.field.field_config.field_option_values, (option, index) =>
     if @props.values?[index]? then @props.values[index] else 0
    return {
      field: @props.field
      values: defaultValues
    }
  handleChange: (event) ->
    # Update the parent fields
    newValues = @state.values.slice(0)
    newValues[event.target.value] = if event.target.checked then 1 else 0
    newField = _.extend({}, @state.field, { values: newValues })
    @setState {
      field: newField
      values: newValues
    }
    @props.updateField @state.field.field_name, newField
  buildOptions: ->
    _this = @
    options = _.map @props.field.field_config.field_option_values, (option, index) ->
      defaultChecked = (_this.state.values[index] is 1)
      fieldID = "fields_#{_this.state.field.field_name}_#{index}"
      `<li key={fieldID} className="field-array__checkboxes__item">
        <div className="field-checkbox">
          <input className="field-checkbox-input" type="checkbox" value={index} defaultChecked={defaultChecked} ref="checkbox" id={fieldID} onChange={_this.handleChange}/>
          <label className="field-checkbox-label" htmlFor={fieldID}>{option}</label>
        </div>
      </li>`
    options
  formatFallback: ->
    if @state.field.field_config.field_fallback?.values?
      @state.field.field_config.field_fallback?.values.join(", ")
  render: ->
    options = @buildOptions()
    return `<div className={this.displayClassName("field-array__checkboxes")}>
        <FieldHeader
          label={this.state.field.field_config.field_label}
          name={this.state.field.field_name}
          hint={this.state.field.field_config.field_hint}
          required={this.state.field.field_config.field_required}
        />
        <div className="field-main field-main--border-top">
          <ul className="field-array__checkboxes__items">
            {options}
          </ul>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`


# Register as available
HeraclesAdmin.availableFields.add
  editorType: "array__checkbox"
  formatProps: (data) ->
    key: data.key
    newRow: data.newRow
    updateField: data.updateField
    field: data.field
    values: data.field.values
  component: FieldArrayCheckbox
