#=require lodash
#=require jquery
#=require react

#=require heracles/admin/components/available_insertables
#=require heracles/admin/lightboxes/lightbox
#=require heracles/admin/lightboxes/lightbox__asset_selector

###* @jsx React.DOM ###

displayMixinOverride =
  isEmpty: (value) ->
    !value?.asset_id?
  componentDidMount: ->
    # super
    @$doc = $(document)
    # # New stuff
    @$doc.on "cover:close, lightbox.closed", => setTimeout(@removeIfEmpty, 0)
    # Open the selector on create
    if @isEmpty(@props.value) then @openAssetSelector()
  getInitialState: ->
    @getAssetData(@props.value.asset_id)
    value: @props.value || {}
    size:  @props.size || "30"
    assetData: false

InsertableAudioDisplay = React.createClass
  mixins: [_.extend {}, InsertableDisplayMixin, displayMixinOverride]
  getAssetData: (assetID) ->
    unless _.isEmpty(assetID)
      request = $.ajax
        url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/assets/#{assetID}"
        dataType: "json"
      request.done @setAssetData

  # Open the asset selector in a lightbox
  openAssetSelector: (e) ->
    e?.preventDefault()
    # Call the lightbox, passing it a callback reference in this component,
    # the fileType limitation, and the currently selected asset
    HeraclesAdmin.availableLightboxes.helper 'AssetSelectorLightbox',
      callback: @onAssetSelection
      fileType: "audio"
      selectedAssets: if @state.assetData then [@state.assetData] else []

  # Callback, passed to the selector
  # Expects an array of assets to come back
  onAssetSelection: (selectedAssets) ->
    if selectedAssets.length > 0
      selection = selectedAssets[0]
      @setAssetData {asset: selection}
    else
      @clearAssetData()

  setAssetData: (data) ->
    newValue = _.extend {}, @state.value
    newValue.asset_id = data.asset.id
    @setState
      assetData: data.asset
    @handleValueChange newValue

  clearAssetData: ->
    # Override only the value data that changes
    newValue = _.extend {}, @state.value
    delete newValue.asset_id
    @setState
      value: newValue
      assetData: false
    @handleValueChange newValue

  hasLinkData: ->
    !_.isEmpty(@state.value.link?.href) || !_.isEmpty(@state.value.link?.pageID) || !_.isEmpty(@state.value.link?.assetID)

  # Display format when asset is selected
  formatSelection: ->
    `<div className="field-asset__display field-asset__display--audio">
      <div className="field-asset__preview">
        <div className="field-asset__display-controls field-asset__display-controls--right">
          <div className="button-group">
            <button className="button insertable-display__edit button button--soft" onClick={this.openAssetSelector}>
              Change audio file
            </button>
          </div>
        </div>
        <span className={"field-asset__preview-proxy field-asset__preview-proxy--"+HeraclesAdmin.helpers.slugify(this.state.assetData.content_type)}/>
      </div>
      <div className="field-asset__details">
        <div className="field-asset__display-controls field-asset__display-controls--right">
          <div className="button-group">
            <button className="button insertable-display__edit button button--soft" onClick={this.editValue}>
              Edit details
            </button>
            <button className="button insertable-display__remove button button--soft" onClick={this.remove}>
              <i className="fa fa-times"/>
            </button>
          </div>
        </div>
        <dl className="field-details-list">
          <dt>Display</dt>
          <dd>{this.state.value.display || "—"}</dd>
          <dt>Title</dt>
          <dd>{this.state.value.title || "—"}</dd>
          <dt>Caption</dt>
          <dd>{this.state.value.caption || "—"}</dd>
          <dt>Show attribution</dt>
          <dd>{(this.state.value.show_attribution === true) ? "Yes" : "No"}</dd>
        </dl>
      </div>
    </div>`

  render: ->
    if @state.assetData
      template = @formatSelection()
    else
      ""
    return `<div className="insertable-display insertable-display-audio" contentEditable="false">
      {template}
    </div>`

InsertableAudioEdit = React.createClass
  mixins: [InsertableEditMixin]

  handleChange: (ref, e) ->
    @state.value[ref] = e.target.value
    @setState value: @state.value

  handleCheckboxChange: (ref, e) ->
    @state.value[ref] = @refs[ref].getDOMNode().checked
    @setState value: @state.value

  _onLinkChange: (type, data) ->
    value = _.extend {}, @state.value
    value.link = data
    @setState value: value

  render: ->
    `<div className="insertable-edit fields--reversed">
      <form onSubmit={this.onSubmit}>
        <h2 className="insertable-edit__title">Edit audio details</h2>
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
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__alt-text">Title</label>
          </div>
          <div className="field-main">
            <input ref="alt" id="edit__alt-text" className="field-text-input" value={this.state.value.title} onChange={this.handleChange.bind(this, "title")} placeholder="Title"/>
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
          <div className="field-main">
            <div className="field-checkbox">
              <input ref="show_attribution" className="field-checkbox-input" type="checkbox" defaultChecked={this.props.value.show_attribution} id="edit__show-page-link" onChange={this.handleCheckboxChange.bind(this, "show_attribution")}/>
              <label className="field-checkbox-label" htmlFor="edit__show-page-link">Show attribution?</label>
            </div>
          </div>
        </div>
        <button type="submit" className="button button--highlight">Save changes</button>
      </form>
    </div>`

HeraclesAdmin.availableInsertables.add
  type:    "audio"
  label:   "Audio"
  icon:    "music"
  display: InsertableAudioDisplay
  edit:    InsertableAudioEdit
