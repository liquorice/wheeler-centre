# Stub out the dependencies. These are all filled by stuff in the
# heracles_admin engine.
#= stub lodash
#= stub jquery
#= stub react

#= stub heracles/admin/components/available_insertables

###* @jsx React.DOM ###

# Display class
# Exists inside the TinyMCE iframe

displayMixinOverride =
  isEmpty: (value) ->
    !value?.quote?

InsertablePullQuoteDisplay = React.createClass
  mixins: [_.extend {}, InsertableDisplayMixin, displayMixinOverride]

  render: ->
    `<div className="insertable-display insertable-display-pull-quote" contentEditable="false">
      <div className="insertable-display-pull-quote__details">
        <div className="insertable-display-pull-quote__controls">
          <div className="button-group">
            <button className="button insertable-display__edit button button--soft" onClick={this.editValue}>
              Edit quote
            </button>
            <button className="button insertable-display__remove button button--soft" onClick={this.remove}>
              <i className="fa fa-times"/>
            </button>
          </div>
        </div>
        {this._formatQuote()}
      </div>
    </div>`

  _formatQuote: ->
    if @state.value.quote?
      attribution = if @state.value.attribution?
        `<p>— {this.state.value.attribution}</p>`
      else
        ""
      `<div className="insertable-display-pull-quote__quote">
        <blockquote>{this.state.value.quote}</blockquote>
        {attribution}
      </div>`
    else
      ""

# Edit class
#
#   value = {
#     quote: "string",
#     display: "string",
#     attribution: "string"
#   }
#
InsertablePullQuoteEdit = React.createClass
  mixins: [InsertableEditMixin]


  handleChange: (ref, e) ->
    @state.value[ref] = e.target.value
    @setState value: @state.value
    console.log @state.value

  hasQuote: ->
    !_.isEmpty @state.value.quote

  render: ->
    `<div className="insertable-edit fields--reversed">
      <form onSubmit={this.onSubmit}>
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__caption">Quote</label>
          </div>
          <div className="field-main">
            <textarea ref="quote" id="edit__quote" className="field-text-input field-size--large insertable-edit__quote" value={this.state.value.quote} onChange={this.handleChange.bind(this, "quote")} placeholder="Quote"/>
          </div>
        </div>
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__caption">Attribution</label>
          </div>
          <div className="field-main">
            <textarea ref="attribution" id="edit__attribution" className="field-text-input insertable-edit__attribution" value={this.state.value.attribution} onChange={this.handleChange.bind(this, "attribution")} placeholder="Attribution"/>
          </div>
        </div>
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__display">Display</label>
          </div>
          <div className="field-main">
            <select ref="alt" id="edit__display" className="field-select" value={this.state.value.display} onChange={this.handleChange.bind(this, "display")}>
              <option/>
              <option>Left-aligned</option>
              <option>Right-aligned</option>
              <option>Full-width</option>
            </select>
          </div>
        </div>
        <button type="submit" className="button button--highlight" disabled={!this.hasQuote()}>Save changes to quote</button>
      </form>
    </div>`


HeraclesAdmin.availableInsertables.add
  type:    "pull_quote"
  label:   "Pull quote"
  icon:    "quote-right"
  display: InsertablePullQuoteDisplay
  edit:    InsertablePullQuoteEdit
