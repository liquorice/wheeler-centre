#= require lodash
#= require react
#= require jquery

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldTextRadio = React.createClass
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
  handleChange: (event) ->
    # Override only the field data that changes
    newValue = event.target.value
    newField = _.extend {}, @state.field,
      value: newValue
    @props.updateField @state.field.field_name, newField
    @setState
      field: newField
      value: newValue
  buildRadioButtons: ->
    _this = @
    groupName = "#{@props.field.field_name}__radio"
    _.map @state.option_values, (option, index) ->
      inputID = "#{_this.props.field.field_name}--#{index}"
      defaultChecked = (_this.state.value is option)
      `<li key={inputID} className="field-text__radio__item">
        <div className="field-radio">
          <input className="field-radio-input" type="radio" id={inputID} name={groupName} value={option} onChange={_this.handleChange} defaultChecked={defaultChecked}/>
          <label className="field-radio-label" htmlFor={inputID}>{option}</label>
        </div>
      </li>`
  formatFallback: ->
    if @state.field.field_config.field_fallback?.value?
      @state.field.field_config.field_fallback?.value
  render: ->
    value = @state.field.value
    radioButtons = @buildRadioButtons()
    return `<div className={this.displayClassName("field-text__radio")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main field-main--border-top">
          <ul className="field-text__radio__items">
            {radioButtons}
          </ul>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`



# Register as available
HeraclesAdmin.availableFields.add
  editorType: "text__radio"
  component: FieldTextRadio
