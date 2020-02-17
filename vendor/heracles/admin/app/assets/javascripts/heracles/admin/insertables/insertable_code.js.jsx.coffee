#=require react

#= require heracles/admin/components/helper_encode
#=require heracles/admin/components/available_insertables

###* @jsx React.DOM ###

displayMixinOverride =
  isEmpty: (value) ->
    !value?.code?

window.InsertableCodeDisplay = React.createClass
  mixins: [_.extend {}, InsertableDisplayMixin, displayMixinOverride]

  render: ->
    return `<div className="insertable-display insertable-display-code" contentEditable="false">
      <div className="insertable-display-code__details">
        <div className="insertable-display-code__controls">
          <div className="button-group">
            <button className="button insertable-display__edit button button--soft" onClick={this.editValue}>
              Edit code
            </button>
            <button className="button insertable-display__remove button button--soft" onClick={this.remove}>
              <i className="fa fa-times"/>
            </button>
          </div>
        </div>
        <pre>{HeraclesAdmin.helpers.htmlDecode(this.state.value.code)}</pre>
      </div>
    </div>`

editMixinOverride =
  getInitialState: ->
    value = _.extend {}, @props.value
    value.code = HeraclesAdmin.helpers.htmlDecode @props.value.code
    value: value
  onSubmit: (e) ->
    e.preventDefault()
    @$doc.trigger("insertable:close")
    # Send the data back
    # Modify the code value to encode it
    value = @state.value
    value.code = HeraclesAdmin.helpers.htmlEncode value.code
    @props.handleValueChange value
    @removeComponent()

window.InsertableCodeEdit = React.createClass
  mixins: [_.extend {}, InsertableEditMixin, editMixinOverride]

  handleChange: (ref, e) ->
    value = _.extend {}, @state.value
    value[ref] = e.target.value
    @setState value: value

  render: ->
    return `<div className="insertable-edit fields--reversed">
      <form onSubmit={this.onSubmit}>
        <h2 className="insertable-edit__title">Edit code</h2>
        <div className="field">
          <div className="field-main">
            <textarea ref="caption" id="edit__caption" className="field-text-input field-mono field-size--large" value={this.state.value.code} onChange={this.handleChange.bind(this, "code")} placeholder="Caption"/>
          </div>
        </div>
        <button type="submit" className="button button--highlight">Save</button>
      </form>
    </div>`

HeraclesAdmin.availableInsertables.add
  type:    "code"
  label:   "Code"
  icon:    "code"
  display: window.InsertableCodeDisplay
  edit:    window.InsertableCodeEdit
