#= require react
#= require lodash

###* @jsx React.DOM ###

window.FieldErrors = React.createClass
  formatBaseErrors: ->
    if @props.errors.base?
      _.map @props.errors.base, (error) ->
        `<li>This field {error}</li>`
  formatOtherErrors: ->
    output = []
    _.forIn @props.errors, (errors, key) ->
      unless key is "base"
        output.push _.map errors, (error) ->
          `<li>{HeraclesAdmin.helpers.text.humanize(key, true)} {error}</li>`
    output
  render: ->
    unless _.isEmpty @props.errors
      `<div className="field-errors copy">
        <ul>
          {this.formatBaseErrors()}
          {this.formatOtherErrors()}
        </ul>
      </div>`
    else
      `<div/>`
