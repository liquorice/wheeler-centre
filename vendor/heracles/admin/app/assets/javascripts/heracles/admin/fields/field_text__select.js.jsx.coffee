#= require lodash
#= require react
#= require jquery
#= require select2

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldTextSelect = React.createClass
  mixins: [FieldMixin]
  propTypes:
    value: React.PropTypes.string
  getInitialState: ->
    option_values = if _.isEmpty(@props.value)
      @props.field.field_config.field_option_values
    else
      _.unique(@props.field.field_config.field_option_values.concat([@props.value]))
    field: @props.field
    value: @props.value
    option_values: option_values
  componentDidMount: ->
    select = $(@refs.selectField.getDOMNode()).select2
      allowClear: true
    select.on "change", @handleChange

  handleChange: (event) ->
    # Override only the field data that changes
    newValue = event.target.value
    newField = _.extend {}, @state.field,
      value: newValue
    @props.updateField @state.field.field_name, newField
    @setState
      field: newField
      value: newValue
  buildSelectOptions: ->
    _.map @state.option_values, (option) ->
      `<option key={option} value={option}>{option}</option>`
  formatFallback: ->
    if @state.field.field_config.field_fallback?.value?
      @state.field.field_config.field_fallback?.value
  render: ->
    value = @state.field.value
    selectOptions = @buildSelectOptions()
    return `<div className={this.displayClassName("field-text")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          <select className="field-select2" ref="selectField" value={value} onChange={this.handleChange} placeholder="Select an option">
            <option/>
            {selectOptions}
          </select>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "text__select"
  component: FieldTextSelect
