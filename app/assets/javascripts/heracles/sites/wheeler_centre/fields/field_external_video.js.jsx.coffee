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
    button_value: 'Load data'
    button_class: 'covered'

  render: ->
    value = @state.field.value
    inputClassName = "field-text-input #{@inputSizeClassName()}"
    buttonClassName = "field-external-video__button field-external-video__button--#{this.state.button_class} button button--soft button--small"
    return `<div className={this.displayClassName("field-external-video")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          <form onSubmit={this.cancelFormSubmit}>
            <input type="text" value={value} ref='fieldInput' className={inputClassName} onChange={this._handleChange}/>
            <button className={buttonClassName} ref='fieldButton' onClick={this._processUrl}>{this.state.button_value}</button>
          </form>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this._formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`

  _processUrl: ->
    _this = @

    @setState
      button_class: 'loading'
      button_value: 'Loading...'

    @disableInputs()

    $.ajax
      url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/fields/external_video/1"
      type: 'put'
      dataType: "json"
      contentType: "application/json"
      success: (data) ->
        _this.setState
          button_value: 'Successfully loaded!'
          button_class: 'success'
        setTimeout(->
          $(_this.refs.fieldButton.getDOMNode()).fadeOut 'slow', ->
            $(@).css
              display:    'block',
            _this.enableInputs()
            _this.setState
              button_value: 'Load data'
              button_class: 'covered'
        , 2000)

  _handleChange: (event) ->
    # Override only the field data that changes
    newValue = event.target.value
    newField = _.extend {}, @state.field,
      value: newValue
    @props.updateField @state.field.field_name, newField
    @setState
      field       : newField
      value       : newValue
      button_class: 'uncovered'

  _formatFallback: ->
    if @state.field.field_config.field_fallback?.value?
      @state.field.field_config.field_fallback?.value

  disableInputs: ->
    $(@refs.fieldButton.getDOMNode()).attr('disabled','disabled')
    $(@refs.fieldInput.getDOMNode()).attr('disabled','disabled')

  enableInputs: ->
    $(@refs.fieldButton.getDOMNode()).removeAttr('disabled')
    $(@refs.fieldInput.getDOMNode()).removeAttr('disabled')


# Register as available
HeraclesAdmin.availableFields.add
  editorType: 'external_video'
  component: FieldExternalVideo
