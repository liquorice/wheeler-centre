#= require react

###* @jsx React.DOM ###

window.FieldHeader = React.createClass
  render: ->
    headerID = "field-header--#{this.props.name}"
    required = if @props.required then "*" else ""
    return `<div className="field-header" id={headerID}>
        <label htmlFor={"fields_" + this.props.name} className="field-label">{this.props.label}{required}</label>
        <span className="field-hint">{this.props.hint}</span>
      </div>`
