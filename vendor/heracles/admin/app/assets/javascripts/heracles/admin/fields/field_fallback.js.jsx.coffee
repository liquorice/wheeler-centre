#= require react

###* @jsx React.DOM ###

window.FieldFallback = React.createClass
  getInitialState: ->
    open: false
  toggle: (e) ->
    unless e.target.className == "field-fallback__link"
      e.preventDefault()
      @setState open: !@state.open
  render: ->
    className = React.addons.classSet
      "field-fallback": true
      "field-fallback--has-content": @props.content?
      "field-fallback--open": @state.open
    iconClassName = React.addons.classSet
      "fa": true
      "fa-chevron-down": !@state.open
      "fa-chevron-up": @state.open
    if @props.content?
      fallbackUrl = "#{HeraclesAdmin.baseURL}sites/#{HeraclesAdmin.siteSlug}/pages/#{@props.field.field_config.field_id_path.replace(/#/, "/edit/#")}"
      content = if typeof @props.content is "string"
        `<div className="field-fallback__content copy" dangerouslySetInnerHTML={{__html: this.props.content}}/>`
      else
        `<div className="field-fallback__content copy">{this.props.content}</div>`
      `<div className={className} onClick={this.toggle}>
        <h3 className="field-fallback__header">
          Content from
          <a href={fallbackUrl} className="field-fallback__link">this page</a>
          will be used if this field is blank
          <i className={iconClassName}/>
          <span className="field-fallback__show">Show</span>
          <span className="field-fallback__hide">Hide</span>
        </h3>
        {content}
      </div>`
    else
      `<div className={className}/>`
