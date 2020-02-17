#= require lodash
#= require react

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldUnsupported = React.createClass
  mixins: [FieldMixin]
  propTypes:
    value: React.PropTypes.string
  getInitialState: ->
    field: @props.field
    showData: false
  toggleData: ->
    @setState showData: @refs.showData.getDOMNode().checked
  render: ->
    value = @state.field
    unsupportedClassName = React.addons.classSet
      "fields-unsupported": true
      "fields-unsupported--hidden": !@state.showData
    fieldsData = if @state.showData then `<pre className="fields-data__data"><code>{JSON.stringify(this.state.field, null, 2)}</code></pre>` else ""
    return `<div className="field field-unsupported">
      <div className="field-header">
        <label className="field-label">
          <span>{this.state.field.field_config.field_label}</span>
        </label>
        <span className="field-hint">This field type is no longer supported</span>
      </div>
      <p className="field-call-to-action">Contact your site’s developer to remove this field.</p>
      <div className={unsupportedClassName}>
        <div className="field-checkbox">
          <input className="field-checkbox-input" type="checkbox" ref="showData" id="fields-data__checkbox" onChange={this.toggleData}/>
          <label className="field-checkbox-label" htmlFor="fields-data__checkbox">Show this field’s data?</label>
        </div>
        {fieldsData}
      </div>
    </div>`

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "unsupported"
  component: FieldUnsupported
