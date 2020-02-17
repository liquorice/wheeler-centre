#= require lodash
#= require react
#= require jquery
#= require select2

#= require heracles/admin/utils/jquery-ui
#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldAssociatedPages = React.createClass
  mixins: [FieldMixin]
  propTypes:
    page_ids: React.PropTypes.array
    pages:    React.PropTypes.array
  getInitialState: ->
    # Merge the page_ids and the pages
    pages = _.map @props.pages, (page, i) =>
      page.id = @props.page_ids[i]
      return page
    typeLabel = if @props.field.field_config.field_page_type?
      @props.field.field_config.field_page_type.replace(/_/, " ")
    else
      "page"
    field: @props.field
    pages: pages || []
    typeLabel: typeLabel
  componentDidMount: ->
    @$el = $(@getDOMNode())
    @_initAddPageSelector()
    @_initSortable()
  render: ->
    `<div className={this.displayClassName("field-associated-pages")}>
      <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
      <div className="field-main">
        <div className="field-associated-pages__form field-addon">
          <input className="field-select2 field-addon-input" type="hidden" ref="addPage"/>
          <button className="field-addon-button button button--soft" onClick={this._addPage}>Add this {this.state.typeLabel}</button>
        </div>
        {this._formatPageList()}
        <FieldFallback field={this.state.field.field_config.field_fallback} content={this._formatFallback()}/>
      </div>
    </div>`

  # Enable the select2 input for adding pages
  _initAddPageSelector: ->
    _this = @
    $addPage = $ @refs.addPage.getDOMNode()
    $addPage.select2
      allowClear: true
      placeholder: "Search for a #{_this.state.typeLabel}"
      ajax:
        url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/pages"
        dataType: "json"
        data: (term, page) ->
          q: term
          page: page
          page_type: _this.props.field.field_config.field_page_type
          page_parent_url: _this.props.field.field_config.field_page_parent_url
        results: (data, page) =>
          # Filter out any pages that are already selected
          pages = _.filter data.pages, (page) =>
            index = _.findIndex @state.pages, (selectedPage) ->
              page.id is selectedPage.id
            return (index is -1)
          results: pages
      # Format the dropdown
      formatResult: (page) ->
        """
          <div class="select2-result__primary">
            #{page.title}<span class="field-mono">&nbsp;/#{page.url} #{if page.published then "" else "(unpublished)"}</span>
          </div>
        """
      # Don't try to escape markup since we're returning HTML
      escapeMarkup: (m) -> m
      # Format the display value when selected
      formatSelection: (page) ->
        """
          <div class="select2-result__primary">
            #{page.title}<span class="field-mono">&nbsp;/#{page.url} #{if page.published then "" else "(unpublished)"}</span>
          </div>
        """
  # Triggered on form submission
  _addPage: (e) ->
    e.preventDefault()
    addedPageID = @refs.addPage.getDOMNode().value
    if addedPageID? and addedPageID != ""
      # Get the full page data
      request = @_getPageData addedPageID
      request.done @_addToSelectedPages
      # Reset the select2
      $(@refs.addPage.getDOMNode()).select2 "val", ""

  _getPageData: (pageID) ->
    request = $.ajax
      url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/pages/#{pageID}"
      dataType: "json"

  _addToSelectedPages: (data) ->
    selectedPages = @state.pages.slice(0)
    selectedPages.push data.page
    @setState
      pages: selectedPages
    @_propagateChangeToParent selectedPages

  _removeFromSelectedPages: (index, e) ->
    e.preventDefault()
    selectedPages = @state.pages.slice(0)
    selectedPages.splice(index, 1)
    @setState pages: selectedPages
    @_propagateChangeToParent selectedPages

  _propagateChangeToParent: (pages) ->
    # Update the parent fields
    newField = _.extend {}, @state.field, page_ids: _.pluck(pages, "id")
    @props.updateField @state.field.field_name, newField

  _initSortable: ->
    @$el.find(".selected-pages").sortable
      axis: "y"
      handle: ".selected-page__handle"
      items: ".selected-page"
      update: @_onSortableUpdate
      tolerance: "pointer"

  _onSortableUpdate: (e) ->
    # Not ideal using data-attrs, but there’s no easy way to pass this data
    orderedPages = []
    currentPages = @state.pages.slice(0)
    @$el.find("[data-position]").each (index) ->
      position = $(this).data "position"
      orderedPages.push currentPages.slice(position, position + 1)[0]
    # Attempt to avoid DOM mutation issues with jQuery UI sortables
    @setState pages: []
    @setState pages: orderedPages
    @_propagateChangeToParent orderedPages

  _formatPageList: ->
    if @state.pages.length > 0
      _this = @
      showHandles = (@state.pages.length > 1)
      pages = _.map @state.pages, (page, index) ->
        `<div className="selected-page" key={page.id + "-" + index} data-position={index}>
          <div className="selected-page__controls">
            <div className="button-group">
              {(showHandles) ? <span className="button button--small button--soft selected-page__handle"><i className="fa fa-arrows"/></span> : null}
              <button className="button button button--soft button--small" onClick={_this._removeFromSelectedPages.bind(_this, index)}>
                <i className="fa fa-times"/>
              </button>
            </div>
          </div>
          <h2 className="selected-page__title">{page.title} <span className="field-mono">&nbsp;&nbsp;/{page.url}</span></h2>
        </div>`
      `<div>
        <div className="selected-pages" ref="selectedPages">
          {pages}
        </div>
      </div>`
    else
      `<div>
        <div className="selected-pages selected-pages--hide"/>
        <div className="field-empty__select">
          <span className="field-empty__select-label">No {this.state.typeLabel}s yet — add them above!</span>
        </div>
      </div>`

  # Remove unnecessary properties from the `page`
  _stripPageData: (page) ->
    propertiesToKeep = ["id", "title"]
    _.pick page, propertiesToKeep

  _formatFallback: ->
    if @state.field.field_config.field_fallback?.page_ids?
      "#{@state.typeLabel} IDs: #{@state.field.field_config.field_fallback?.page_ids}"

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "associated_pages"
  formatProps: (data) ->
    key: data.key
    newRow: data.newRow
    updateField: data.updateField
    field: data.field
    page_ids: data.field.page_ids
    pages:    data.field.pages
  component: FieldAssociatedPages
