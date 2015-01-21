# Stub out the dependencies. These are all filled by stuff in the
# `heracles_admin` engine.
#= stub lodash
#= stub react
#= stub jquery
#= stub select2

#= stub heracles/admin/components/available_fields
#= stub heracles/admin/fields/field_header
#= stub heracles/admin/fields/field_fallback
#= stub heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldExternalVideo = React.createClass
  mixins: [FieldMixin]
  propTypes:
    value: React.PropTypes.string
  getInitialState: ->
    field: @props.field
    value: @props.value
  handleChange: (event) ->
    # Override only the field data that changes
    newValue = event.target.value
    newField = _.extend {}, @state.field,
      value: newValue
    @props.updateField @state.field.field_name, newField
    @setState
      field: newField
      value: newValue
  formatFallback: ->
    if @state.field.field_config.field_fallback?.value?
      @state.field.field_config.field_fallback?.value
  render: ->
    value = @state.field.value
    inputClassName = "field-text-input #{@inputSizeClassName()}"
    inputElement = if !@props.field.field_config.field_editor_input_size? or @props.field.field_config.field_editor_input_size is "single"
      `<input type="text" className={inputClassName} value={value} onChange={this.handleChange}/>`
    else
      `<textarea className={inputClassName} value={value} onChange={this.handleChange}/>`
    return `<div className={this.displayClassName("field-text")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          <form onSubmit={this.cancelFormSubmit}>
            {inputElement}
          </form>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`


# Register as available
HeraclesAdmin.availableFields.add
  editorType: 'external_video'
  component: FieldExternalVideo
