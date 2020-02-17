#= require lodash
#= require react

#= require_self

###* @jsx React.DOM ###

window.FieldsNav = React.createClass
  render: ->
    items = _.map @props.fields, (field) ->
      fieldHeaderID = "field-header--#{field.field_name}"
      return `<li key={fieldHeaderID} className="fields-nav__list-item">
        <a className="fields-nav__anchor" href={"#" + fieldHeaderID}>{field.field_config.field_label}</a>
      </li>`
    return `<div className="fields-nav">
      <ul className="fields-nav__list">
        <li className="fields-nav__list-item">
          <a className="fields-nav__anchor" href="#form-body">Title</a>
        </li>
        {items}
      </ul>
    </div>`
