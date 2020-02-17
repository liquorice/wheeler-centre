#= require lodash
#= require react
#= require react-radio-group/react-radiogroup
#= require jquery
#= require momentjs

#= require heracles/admin/lightboxes/lightbox__asset_details

###* @jsx React.DOM ###

#
# AssetSearchFetcher
# - Simple wrapper for handling the AJAX API actions for assets
#
class AssetSearchFetcher
  constructor: ->
    @baseUrl = "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/assets"
  destroy: (id) ->
    request = $.ajax
      url: "#{@baseUrl}/#{id}"
      type: "delete"
      dataType: "json"
      contentType: "application/json"

class AssetPoller
  constructor: (@id, @callback) ->
    @baseUrl = "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/assets"
    @poll()
  poll: ->
    _this = @
    @timer = setTimeout(->
      request = $.ajax
        url: "#{_this.baseUrl}/#{_this.id}"
        dataType: "json"
        contentType: "application/json"
      request.then (response) ->
        if response.asset?.processed
          _this.destroy()
          _this.callback()
        else
          _this.poll()
    , 10 * 1000)
  destroy: ->
    clearTimeout @timer

HeraclesAdmin.AssetSearch = React.createClass
  fetcher: new AssetSearchFetcher()
  pollers: []

  getInitialState: ->
    # Assign the clickhandler if one was passed
    # I'm thinking that there has to be a nicer pattern to use here
    @onItemClick = if @props.clickHandler
      (asset, e) =>
        if asset.processed
          @props.clickHandler(asset, e)
        else
          e.preventDefault()
    else
      @showImageDetails
    # Set default search fields value
    @fieldsValue = 'filename'
    # Run the initial search
    @doSearch ""
    @bindEvents $(document)
    return {
      assets: []
      loading: true
      links: ""
      currentPage: 1
      selectedAssetIds: []
    }

  onDelete: (asset, e) ->
    e.preventDefault()
    if confirm("Are you sure? This asset will be deleted permanently.")
      request = @fetcher.destroy(asset.id)
      request.done(@onDeleteDone.bind(this, asset.id)).fail(@onDeleteFail)
    false

  onDeleteDone: (id) ->
    target = @refs["asset#{id}"].getDOMNode()
    $(target).fadeOut 'slow', ->
      React.unmountComponentAtNode @
      $(@).remove()

  onDeleteFail: (errors) ->
    for error, message of error.responseJSON.errors
      console?.log "#{error} #{message}"

  showImageDetails: (asset, e) ->
    e.preventDefault()
    HeraclesAdmin.availableLightboxes.helper 'AssetDetailsLightbox', asset: asset

  refreshResults: () ->
    @doSearch(@refs.searchInput.getDOMNode().value)

  bindEvents: ($doc) ->
    $doc.bind "AssetUploader:uploadComplete", =>
      @refreshResults()
    $doc.bind "AssetSelector:updateSelected", (e, assets) =>
      @setState { selectedAssetIds: _.pluck assets, 'id' }

  componentWillUnmount: ->
    $doc = $ document
    $doc.unbind "AssetUploader:uploadComplete"
    $doc.unbind "AssetSelector:updateSelected"

  setResults: (data, str, response) ->
    @updatePollers _.filter data.assets, (asset) -> !asset.processed
    $container = $ @refs.assetContainer.getDOMNode()
    @setState
      assets: data.assets
      pagination: data.pagination
      loading: false
    $container.fadeTo 500, 1

  # Debounced function for doing the AJAX request
  doSearch: _.debounce((query) ->
    @setState { loading: true }
    if @search? then @search.abort()
    $container = $ @refs.assetContainer.getDOMNode()
    $container.css { opacity: 0 }
    fields = @fieldsValue
    @search = $.ajax
      url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/assets"
      dataType: "json"
      data:
        q: query
        page: @state.currentPage
        type: @props.fileType
        fields: fields
    @search.done @setResults
  , 400)

  onSearch: (e) ->
    @setState { currentPage: 1 }
    @doSearch e.target.value

  fieldsChange: (e) ->
    @fieldsValue = e.target.value
    @refreshResults()

  paginateLink: (pageNum, e) ->
    e.preventDefault()
    @setState { currentPage: pageNum }
    @refreshResults()

  updatePollers: (assets) ->
    _.each @pollers, (poller) -> poller.destroy()
    @pollers = _.map assets, (asset) => new AssetPoller(asset.id, @refreshResults)

  getPageWindow: (start, direction, total_pages, pageWindow) ->
    if direction == "down"
      end = start + pageWindow / 2
      end = total_pages if end > total_pages
      start = end - pageWindow
    else
      start = start - pageWindow / 2
      start = 1 if start < 1
      end = start + pageWindow

    _.filter([start..end], (num) ->
      num > 0 && num <= total_pages
    )

  renderLinks: ->
    _this = @
    pageWindow = 10
    {current_page, total_pages, next_page, prev_page, last_page, first_page } = @state.pagination

    # Mash up the pagination windows
    bottomWindowStart = if current_page < (total_pages / 2)
      current_page
    else
      1

    topWindowStart = if current_page > (total_pages / 2)
      current_page
    else
      total_pages

    bottomWindow = @getPageWindow(bottomWindowStart, "up", total_pages, pageWindow)
    topWindow = @getPageWindow(topWindowStart, "down", total_pages, pageWindow)
    topWindow = _.filter(topWindow, (num) ->
      !_.includes(bottomWindow, num)
    )

    bottomWindowLinks = _.map(bottomWindow, (pageNum) ->
      return `<li>
        <button onClick={_this.paginateLink.bind(_this, pageNum)}>
          { (pageNum == current_page) ? <strong>{pageNum}</strong> : pageNum }
        </button>
      </li>`
    )
    topWindowLinks = _.map(topWindow, (pageNum) ->
      return `<li>
        <button onClick={_this.paginateLink.bind(_this, pageNum)}>
          { (pageNum == current_page) ? <strong>{pageNum}</strong> : pageNum }
        </button>
      </li>`
    )

    # Collate the individual links
    return `<div className="asset-selector-results__pagination">
      <div className="asset-selector-results__pagination-prev">
        { (!first_page) ? <button onClick={_this.paginateLink.bind(_this, 1)}>• First</button> : '' }
        { (prev_page) ? <button onClick={_this.paginateLink.bind(_this, prev_page)}>← Prev</button> : '' }
      </div>
      <ul className="asset-selector-results__pagination-bottom-window">
        {bottomWindowLinks}
      </ul>
      <div className="asset-selector-results__pagination-next">
        { (next_page) ? <button onClick={_this.paginateLink.bind(_this, next_page)}>Next →</button> : '' }
        { (!last_page) ? <button onClick={_this.paginateLink.bind(_this, total_pages)}>Last •</button> : '' }
      </div>
      <ul className="asset-selector-results__pagination-top-window">
        {topWindowLinks}
      </ul>
    </div>`

  formatResults: ->
    _this = @
    if @state.assets.length > 0
      items = _.map @state.assets, (asset) ->
        assetLabel = if asset.title
          "#{asset.title} — #{asset.file_name}"
        else
          asset.file_name
        formattedDate = moment(asset.created_at).fromNow()
        thumbnail = if asset.content_type.match("image.*") then asset.thumbnail_url
        ref = "asset#{asset.id}"

        className = React.addons.classSet
          "asset-selector-result": true
          "asset-selector-result--unprocessed": !asset.processed
          "asset-selector-result--selectable": (!_this.props.clickHandler? || (_this.props.clickHandler? && asset.processed))
          "asset-selector-result--selected": _.contains _this.state.selectedAssetIds, asset.id

        preview = if thumbnail?
          aspect = if (asset.corrected_width / asset.corrected_height) > 1.4 then "width" else "height"
          `<img className={"asset-selector-result__preview-image  asset-selector-selected__preview-image--" + aspect} src={thumbnail}/>`
        else
          `<span className={"asset-selector-result__preview-proxy asset-selector-result__preview-proxy--"+HeraclesAdmin.helpers.slugify(asset.content_type)}/>`

        flag = if !asset.processed
          `<div className="asset-selector-result__flag">
            <span>Processing</span>
          </div>`
        else
            ""

        `<div ref={ref} key={asset.id} className={className}>
          <a href="#" className="asset-selector-result__link" onClick={_this.onItemClick.bind(this, asset)}>
            <div className="asset-selector-result__preview">
              {flag}
              <div className="asset-selector-result__preview-inner">
                {preview}
              </div>
            </div>
            <p className="asset-selector-result__file-name" title={assetLabel}>{assetLabel}</p>
            <p className="asset-selector-result__date">{formattedDate}</p>
          </a>
          <p className="asset-selector-result__actions">
            <a href="#" onClick={_this.onDelete.bind(this, asset)}>delete</a>
          </p>
        </div>`
      `<div className="asset-selector-results">
        <div className="asset-selector-results__list">{items}</div>
        {this.renderLinks()}
      </div>`
    else
      `<p className="asset-selector-results__empty">No results.</p>`

  render: ->
    results = if @state.loading
      `<div className="asset-selector__loading">
        Loading <i className="fa fa-refresh"/>
      </div>`
    else
      @formatResults()

    processing = if @pollers.length > 0
      `<p className="asset-selector__processing">Watching processed status for {this.pollers.length} asset{(this.pollers.length > 1) ? 's' : ''}</p>`
    else
      ''

    `<div>
      <div className="asset-selector-search">
       <input className="field-text-input asset-selector-search-input" id="asset-search" ref="searchInput" onChange={this.onSearch} placeholder="Search for assets ..." type="search" />
       <label htmlFor="asset-search" className="asset-selector-search-label"><i className="fa fa-search"></i></label>
      </div>
      <div className="asset-selector-fields">
        <RadioGroup name="fields" value={this.fieldsValue} onChange={this.fieldsChange}>
          <label className="asset-selector-fields-label">
            <input type="radio" value="filename" />by filename
          </label>
          <label className="asset-selector-fields-label">
            <input type="radio" value="title" />by title
          </label>
          <label className="asset-selector-fields-label">
            <input type="radio" value="tags" />by tag
          </label>
        </RadioGroup>
        {processing}
      </div>

      <div className="asset-selector-main" ref="assetContainer">{results}</div>
    </div>`

# Load assetSearch into the asset page
AssetSearch = HeraclesAdmin.AssetSearch
class AssetSearchWrapper
  constructor: (@$el, @el) ->
    React.renderComponent AssetSearch(@el), @el

HeraclesAdmin.views.assetSearchWrapper = ($el, el) -> new AssetSearchWrapper $el, el
