#= require lodash
#= require react

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header

###* @jsx React.DOM ###

FieldInfo = React.createClass
  mixins: [FieldMixin]
  getInitialState: ->
    state = _.extend {}, field: @props.field
    return state
  render: ->
    text = @state.field.field_config.field_text
    fieldID = "fields_" + this.state.field.field_name
    if this.state.field.field_config.field_show_header
      return `<div className={this.displayClassName("field-info")}>
          <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
          <div className="field-main field-main--border-top">
            <div className="copy" dangerouslySetInnerHTML={{__html: text}} />
          </div>
        </div>`
    else
      return `<div className={this.displayClassName("field-info")}>
          <div className="field-main">
            <div className="copy" dangerouslySetInnerHTML={{__html: text}} />
          </div>
        </div>`

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "info"
  component: FieldInfo
