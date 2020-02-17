#= require lodash
#= require react

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldInteger = React.createClass
  mixins: [FieldMixin]
  propTypes:
    value: React.PropTypes.number
  getInitialState: ->
    field: @props.field
    value: parseInt @props.value
  handleChange: (event) ->
    # Override only the field data that changes
    newValue = parseInt event.target.value
    newField = _.extend {}, @state.field, value: newValue
    @props.updateField @state.field.field_name, newField
    @setState
      field: newField
      value: newValue
  formatFallback: ->
    if @state.field.field_config.field_fallback?.value?
      @state.field.field_config.field_fallback?.value
  render: ->
    value = @state.value
    return `<div className={this.displayClassName("field-text")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          <input type="number" step="1" className="field-text-input" defaultValue={value} onChange={this.handleChange}/>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "integer"
  component: FieldInteger
