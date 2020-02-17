#=require lodash
#=require jquery
#=require react

#=require heracles/admin/components/available_insertables
#=require heracles/admin/lightboxes/lightbox
#=require heracles/admin/lightboxes/lightbox__savedsearch_selector

###* @jsx React.DOM ###


displayMixinOverride = {

  componentDidMount: ->
    # super
    @$doc = $(document)
    @$doc.on "cover:close", => setTimeout(@removeIfEmpty, 0)
    # New stuff
    unless @props.value.saved_search? then @openSavedsearchSelectorLightbox()

}


InsertableSavedsearchDisplay = React.createClass

  # @TODO: Create simple template for preview

  mixins: [_.extend {}, InsertableDisplayMixin, displayMixinOverride]

  render: ->

    `<div className="insertable-display insertable-display-savedsearch" contentEditable="false">
      <div className="insertable-display-savedsearch__details">
        <div className="insertable-display-savedsearch__controls">
          <div className="button-group">
            <button className="button insertable-display__edit button button--soft" onClick={this.editValue}>
              Edit details
            </button>
            <button className="button insertable-display__edit button button--soft" onClick={this.openSavedsearchSelectorLightbox}>
              Change conditions
            </button>
            <button className="button insertable-display__remove button button--soft" onClick={this.remove}>
              <i className="fa fa-times"/>
            </button>
          </div>
        </div>
        {this.formatDetails()}
        {this.formatConditions()}
      </div>
    </div>`

  formatDetails: ->
    `<p className="insertable-display-savedsearch__title">{this.state.value.title}</p>`

  formatConditions: ->
    if @state.value.saved_search?
      conditions = @state.value.saved_search.conditions
      conditionItems = _.map conditions, (item) ->
        if item.condition_type == 'field'
          `<li><b>{item.condition_type}</b> {item.field} is {item.match_type} {item.match_value}</li>`
        else
          `<li><b>{item.condition_type}</b> is {item.match_value}</li>`
      `<p>
        Search with <b>{this.state.value.saved_search.combination_type}</b> of {conditions.length} defined conditions:
        <ul>
          {conditionItems}
        </ul>
      </p>`
    else
      `<p className="insertable-display-link-sections__empty">Saved search conditions are not defined.</p>`

  openSavedsearchSelectorLightbox: (e) ->

    e?.preventDefault()
    # Call the lightbox, passing it a callback reference in this component
    HeraclesAdmin.availableLightboxes.helper 'SavedsearchSelectorLightbox',
      callback: @onSavedsearchSelectorLightbox
      saved_search: if @state.value.saved_search then @state.value.saved_search else undefined

  onSavedsearchSelectorLightbox: (saved_search) ->

    value = _.extend {}, @state.value, saved_search: saved_search
    @setState value : value
    @handleValueChange value


InsertableSavedsearchEdit = React.createClass
  mixins: [InsertableEditMixin]

  handleChange: (ref, e) ->
    @state.value[ref] = e.target.value
    @setState value: @state.value

  render: ->
    return `<div className="insertable-edit fields--reversed">
      <form onSubmit={this.onSubmit}>
        <h2 className="insertable-edit__title">Edit saved search details</h2>
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__title">Title</label>
          </div>
          <div className="field-main">
            <input ref="title" id="edit__title" className="field-text-input" value={this.state.value.title} onChange={this.handleChange.bind(this, "title")} placeholder="Title"/>
          </div>
        </div>
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__caption">Caption</label>
          </div>
          <div className="field-main">
            <textarea ref="caption" id="edit__caption" className="field-text-input insertable-edit__caption" value={this.state.value.caption} onChange={this.handleChange.bind(this, "caption")} placeholder="Caption"/>
          </div>
        </div>
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__width">Maximum results</label>
          </div>
          <div className="field-name">
            <input type="number" ref="max_results" id="edit__width" className="field-text-input insertable-edit__width" value={this.state.value.max_results} onChange={this.handleChange.bind(this, "max_results")} placeholder="Maximum results, leave blank for no limit"/>
          </div>
        </div>
        <button type="submit" className="button button--highlight">Save changes to image</button>
      </form>
    </div>`


HeraclesAdmin.availableInsertables.add
  type:    "saved_search"
  label:   "Saved search"
  icon:    "search"
  display: InsertableSavedsearchDisplay
  edit:    InsertableSavedsearchEdit
