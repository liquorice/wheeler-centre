#= require lodash
#= require react
#= require jquery
#= require select2

#= require heracles/admin/components/available_fields
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldAssociatedPage = React.createClass
  mixins: [FieldMixin]
  propTypes:
    page_ids: React.PropTypes.array
    pages:    React.PropTypes.array
  _pagesCache: []
  getInitialState: ->
    typeLabel = if @props.field.field_config.field_page_type?
      @props.field.field_config.field_page_type.replace(/_/, " ")
    else
      "page"
    field: @props.field
    page_ids: @props.page_ids
    pages: @props.pages || []
    typeLabel: typeLabel
  componentDidMount: ->
    _this = @
    input = $(@refs.pageID.getDOMNode())

    input.select2
      allowClear: true
      placeholder: "Select a related #{@state.typeLabel}"
      ajax:
        url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/pages"
        dataType: "json"
        data: (term, page) ->
          q: term
          page: page
          page_type: _this.props.field.field_config.field_page_type
          page_parent_url: _this.props.field.field_config.field_page_parent_url
        results: (data, page) ->
          _this._pagesCache = data.pages
          results: data.pages
      # Handle the initial selection
      initSelection: (element, callback) =>
        if @props.page_ids?
          callback @props.pages[0]

      # Format the dropdown
      formatResult: (page) ->
        """
          <div class="select2-result__primary">
            #{page.title} <span class="field-mono">&nbsp;/#{page.url} #{if page.published then "" else "(unpublished)"}</span>
          </div>
        """
      # Don't try to escape markup since we're returning HTML
      escapeMarkup: (m) -> m
      # Format the display value when selected
      formatSelection: (page) ->
        """
          <div class="select2-selection__primary">
            #{page.title}
            <span class="field-mono">&nbsp;/#{page.url} #{if page.published then "" else "(unpublished)"}</span>
          </div>
        """
    # Manually trigger change
    input.on "change", @handleChange

  handleChange: (event) ->
    unless _.isEmpty(event.target.value)
      page = @_stripPageData _.find @_pagesCache, (page) -> page.id is event.target.value
      # Override only the field data that changes
      newValue = event.target.value
      newField = _.extend {}, @state.field,
        page_ids: [newValue]
        pages: [page]
      @props.updateField @state.field.field_name, newField
      @setState
        field: newField
        page_ids: [newValue]
        pages: [page]
    else
      # Clear things out
      newField = _.extend {}, @state.field
      delete newField.page_ids
      delete newField.pages
      @props.updateField @state.field.field_name, newField
      @setState field: newField

  formatFallback: ->
    if @state.field.field_config.field_fallback?.page_ids?
      "Page ids: #{@state.field.field_config.field_fallback?.page_ids.join(", ")}"
  render: ->
    value = if @state.field.page_ids? then @state.field.page_ids[0] else ""
    return `<div className={this.displayClassName("field-text")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          <input className="field-select2" type="hidden" ref="pageID" value={value}/>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`

  _stripPageData: (page) ->
    propertiesToKeep = ["id", "title"]
    _.pick page, propertiesToKeep

# Register as available
HeraclesAdmin.availableFields.add
  editorType: "associated_pages__singular"
  formatProps: (data) ->
    key: data.key
    newRow: data.newRow
    updateField: data.updateField
    field: data.field
    page_ids: data.field.page_ids
    pages:    data.field.pages
  component: FieldAssociatedPage
