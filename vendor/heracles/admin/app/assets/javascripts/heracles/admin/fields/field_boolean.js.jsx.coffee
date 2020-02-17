#= require lodash
#= require react

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldBoolean = React.createClass
  mixins: [FieldMixin]
  getInitialState: ->
    state = _.extend {}, field: @props.field
    state.field.value = if state.field.value? and (state.field.value is true or state.field.value is 1)
      1
    else
      0
    return state
  handleChange: (event) ->
    checked = @refs.checkbox.getDOMNode().checked
    # Override only the field data that changes
    newField = _.extend {}, @state.field,
      value: if checked then 1 else 0
    @props.updateField @state.field.field_name, newField
    @setState field: newField
  formatFallback: ->
    if @state.field.field_config.field_fallback?.value?
      @state.field.field_config.field_fallback?.value
  render: ->
    defaultChecked = (@state.field.value is 1)
    fieldID = "fields_" + this.state.field.field_name
    return `<div className={this.displayClassName("field-boolean")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main field-main--border-top">
          <div className="field-checkbox">
            <input className="field-checkbox-input" type="checkbox" defaultChecked={defaultChecked} ref="checkbox" id={fieldID} onChange={this.handleChange}/>
            <label className="field-checkbox-label" htmlFor={fieldID}>{this.state.field.field_config.field_question_text}</label>
          </div>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "boolean"
  component: FieldBoolean
