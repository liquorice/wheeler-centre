#=require lodash
#=require jquery
#=require react

#=require heracles/admin/components/helper_embedly
#=require heracles/admin/components/available_insertables
#=require heracles/admin/lightboxes/lightbox
#=require heracles/admin/lightboxes/lightbox__asset_selector

###* @jsx React.DOM ###

displayMixinOverride =
  isEmpty: (value) ->
    !value?.url?
  getInitialState: ->
    @getAssetData(@props.value.asset_id)
    size:  @props.size || "30"
    value: @props.value
    assetData: false

InsertableVideoDisplay = React.createClass
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
      fileType: "image"
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

  formatControls: ->
    if @state.assetData
      removeButton = `<button className="button button button--soft" onClick={this.clearAssetData}>
        <i className="fa fa-times"/>
      </button>`
      buttonText = "Change poster image"
    else
      removeButton = ""
      buttonText = "Select poster image"
    `<div className="field-asset__display-controls field-asset__display-controls--right">
      <div className="button-group">
        <button className="button insertable-display__edit button button--soft" onClick={this.openAssetSelector}>
          {buttonText}
        </button>
        {removeButton}
      </div>
    </div>`

  # Display format when asset is selected
  formatSelection: ->
    previewURL = if @state.assetData.thumbnail_url? then @state.assetData.thumbnail_url else @state.value.embedData.thumbnail_url
    aspect = if (@state.assetData.corrected_width / @state.assetData.corrected_height) > 1.4 then "width" else "height"
    `<div className="field-asset__display">
      <div className="field-asset__preview">
        {this.formatControls()}
        <img src={previewURL} className={"field-asset__preview-image field-asset__preview-image--" + aspect}/>
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
          <dt>URL</dt>
          <dd>{this.state.value.url || "—"}</dd>
          <dt>Display</dt>
          <dd>{this.state.value.display || "—"}</dd>
          <dt>Caption</dt>
          <dd>{this.state.value.caption || "—"}</dd>
          <dt>{this.state.value.embedData.provider_name} details</dt>
          <dd>{this.state.value.embedData.description || "—"}</dd>
        </dl>
      </div>
    </div>`

  render: ->
    if @state.value.embedData
      template = @formatSelection()
    else
      "Enter video details"
    return `<div className="insertable-display insertable-display-video" contentEditable="false">
      {template}
    </div>`

editMixinOverride = {
  getInitialState: ->
    return {
      loading: false
      value: @props.value
    }
}

InsertableVideoEdit = React.createClass
  mixins: [InsertableEditMixin]

  handleChange: (ref, e) ->
    @state.value[ref] = e.target.value
    @setState value: @state.value

  setEmbedData: (data) ->
    if data[0].type is "error"
      newValue = _.extend {}, @state.value
      delete newValue["embedData"]
    else
      newValue = _.extend {}, @state.value, {embedData: data[0]}
    @setState
      value: newValue
      loading: false
    @props.handleValueChange newValue

  onGetEmbedData: _.throttle((query) ->
    @setState loading: true
    request = HeraclesAdmin.helpers.embedly.getUrl(query)
    request.success @setEmbedData
  , 500)

  getEmbedData: (e) ->
    @state.value["url"] = e.target.value
    @setState value: @state.value
    @onGetEmbedData e.target.value

  hasEmbedData: ->
    !_.isEmpty @state.value.embedData

  onButtonClick: (e) ->
    unless @hasEmbedData() then e.preventDefault()

  render: ->
    loadingIcon = if @state.loading then `<div className="loading-state"><i className="fa fa-refresh loading-state__icon"/></div>` else ""
    return `<div className="insertable-edit fields--reversed">
      <form onSubmit={this.onSubmit}>
        <h2 className="insertable-edit__title">Edit video details</h2>
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__display">URL</label>
          </div>
          <div className="field-main">
            {loadingIcon}
            <input ref="url" id="edit__url" className="field-text-input insertable-edit__url" value={this.state.value.url} onChange={this.getEmbedData} placeholder="Enter a video URL"/>
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
        <div className="field">
          <div className="field-header">
            <label className="field-label" htmlFor="edit__caption">Caption</label>
          </div>
          <div className="field-main">
            <textarea ref="caption" id="edit__caption" className="field-text-input insertable-edit__caption" value={this.state.value.caption} onChange={this.handleChange.bind(this, "caption")} placeholder="Caption"/>
          </div>
        </div>
        <button type="submit" className={"button button--highlight" + (this.hasEmbedData() ? "" : " button--disabled")}  onClick={this.onButtonClick}>Save changes to video</button>
      </form>
    </div>`

HeraclesAdmin.availableInsertables.add
  type:    "video"
  label:   "Video"
  icon:    "video-camera"
  display: InsertableVideoDisplay
  edit:    InsertableVideoEdit
