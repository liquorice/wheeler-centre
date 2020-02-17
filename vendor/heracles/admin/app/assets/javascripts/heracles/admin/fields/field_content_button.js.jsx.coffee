#= require react

###* @jsx React.DOM ###

window.FieldContentButton = React.createClass
  handleClick: (event) ->
    event.preventDefault()
    @props.handleButtonClick(@)
  render: ->
    active = @props.active
    className = "field-content-editor__control-btn field-content-editor__control-btn--#{@props.type}"
    if active then className = "#{className} active"
    if @props.type is "bold"
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        <i className="fa fa-bold"/>
      </a>`
    else if @props.type is "italic"
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        <i className="fa fa-italic"/>
      </a>`
    else if @props.type is "ul"
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        <i className="fa fa-list-ul"/>
      </a>`
    else if @props.type is "ol"
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        <i className="fa fa-list-ol"/>
      </a>`
    else if @props.type is "ol"
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        <i className="fa fa-list-ol"/>
      </a>`
    else if @props.type is "quote"
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        <i className="fa fa-quote-left"/>
      </a>`
    else if @props.type is "hr"
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        <i className="fa fa-minus"/>
      </a>`
    else if @props.type is "link"
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        {(active) ? <i className="fa fa-unlink"/> : <i className="fa fa-link"/>}
      </a>`
    else if @props.type.match /h[0-5]/
      level = @props.type.match(/h([0-5])/)[1]
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        Level {level}
      </a>`
    else if @props.type.match /insertable-/
      button = `<a key={this.props.type} href={"#" + this.props.type} className={className} onClick={this.handleClick}>
        <i className={"field-content-editor__dropdown-icon fa fa-" + this.props.icon}/>
        <span className="field-content-editor__dropdown-label">{this.props.label}</span>
      </a>`
    return button
