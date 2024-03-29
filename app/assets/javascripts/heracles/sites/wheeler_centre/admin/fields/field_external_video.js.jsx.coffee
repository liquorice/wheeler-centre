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
#= stub heracles/admin/components/helper_embedly


###* @jsx React.DOM ###

FieldExternalVideo = React.createClass

  mixins: [FieldMixin]
  propTypes:
    value: React.PropTypes.string

  getInitialState: ->
    field: @props.field
    value: @props.value
    label:
      status: 'hidden'
    disabled: false

  render: ->
    value = @state.field.value

    inputClassName = "field-text-input #{@inputSizeClassName()}"

    videoLabelClassname = "field-external-video__label field-external-video__label--#{this.state.label.status} button button--soft button--small"
    videoLabel = if @state.label.status != 'hidden'
      `<i className={videoLabelClassname} ref='fieldLabel'>{this.state.label.title}</i>`

    buttonTitle = if @state.field.embed?
      'Refresh'
    else
      'Load'

    videoPreview = if @state.field.embed?
      `<div className="field-external-video__preview">
        <div className="field-external-video__preview-pic">
          <img src={this.state.field.embed.thumbnail_url} />
        </div>
        <div className="field-external-video__preview-field field-external-video__preview-field--title">
          <b>Title:</b>
          {this.state.field.embed.title}
        </div>
        <div className="field-external-video__preview-field field-external-video__preview-field--duration">
          <b>Duration:</b>
          {this.state.field.embed.duration}
        </div>
        <div className="field-external-video__preview-field">
          <a className="field-external-video__preview-clear" href="#" onClick={this._handleClear}>
            <i className="fa fa-times">&nbsp;</i>
            Clear
          </a>
        </div>
      </div>`

    return `<div className={this.displayClassName("field-external-video")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          <form onSubmit={this.cancelFormSubmit} className='field-external-video__form'>
            <div className="field-external-video__input">
              <input type="text" value={value} ref='fieldInput' className={inputClassName} onChange={this._handleChange} disabled={this.state.disabled} />
              {videoLabel}
            </div>
            <button className="field-external-video__button field-addon-button button button--soft" onClick={this._processUrl} disabled={this.state.disabled}>{buttonTitle} data</button>
          </form>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this._formatFallback()}/>
          <FieldErrors errors={this.state.field.errors}/>
          {videoPreview}
        </div>
      </div>`

  _processUrl: ->
    _this = @

    @setState
      label:
        title: 'Loading...'
        status: 'loading'
      disabled: true

    embedDataLoaded = false

    request = HeraclesAdmin.helpers.embedly.getUrl(_this.props.value)
    request.success (data) ->
      unless data[0].type is "error"
        embedDataLoaded = true
        newField = _.extend {}, _this.state.field,
          embed: data[0]
        _this.props.updateField _this.state.field.field_name, newField
        _this.setState
          field: newField
        _this._checkDataLoaded(embedDataLoaded)

  _checkDataLoaded: (embedDataLoaded) ->
    _this = @
    if embedDataLoaded
      # Update field state and label
      @setState
        label:
          title: 'Successfully loaded!'
          status: 'loaded'
      setTimeout(=>
        $(_this.refs.fieldLabel.getDOMNode()).fadeOut 'slow', ->
          # Hide label block
          _this.setState
            label:
              status: 'hidden'
            disabled: false
          # Revert proper display property to label after fadeOut
          $(_this).css display: 'block',
      , 2000)

  _handleClear: (event) ->
    newField = _.extend {}, @state.field,
      embed: null
    @props.updateField @state.field.field_name, newField
    @setState field : newField
    event.preventDefault()

  _handleChange: (event) ->
    # Override only the field data that changes
    newValue = event.target.value
    newField = _.extend {}, @state.field,
      value: newValue
    @props.updateField @state.field.field_name, newField
    @setState field : newField

  _formatFallback: ->
    if @state.field.field_config.field_fallback?.value?
      @state.field.field_config.field_fallback?.value

# Register as available
HeraclesAdmin.availableFields.add
  editorType: 'external_video'
  component: FieldExternalVideo
