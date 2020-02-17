#= require lodash
#= require react

#= require_self

###* @jsx React.DOM ###

formatTagSelection = (tag) ->
  if tag.count > 0
    """<span class="field-mono">&nbsp;(#{tag.count})</span>"""
  else if tag.count is 0
    """<span class="field-mono">&nbsp;(new)</span>"""
  else
    ""

window.FieldsTags = React.createClass

  componentDidMount: ->
    $(@refs.fieldTagsInput.getDOMNode()).select2
      tags: true
      multiple: true
      separator: window.HeraclesAdmin.options.tagDelimiter
      tokenSeparators: [window.HeraclesAdmin.options.tagDelimiter]
      # Dynamically create a choice even though we're loading AJAX data
      createSearchChoice: (term, data) ->
        matches = $(data).filter -> this.text?.localeCompare(term) is 0
        if (matches.length is 0)
          id: term,
          name: term
          count: 0
      ajax:
        transport: (params) ->
          callback = params.success
          params.success = (data, textStatus, jqXHR) ->
            callback {
              data: data,
              perPage: jqXHR.getResponseHeader('Per-Page')
              total: jqXHR.getResponseHeader('Total')
            }, textStatus, jqXHR
          $.ajax(params)
        url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/tags"
        dataType: "json"
        data: (term, page) ->
          q: term
          page: page
        results: (response, page, xhr) ->
          # We don't want to set actual IDs, just tag names
          results: _.map response.data.tags, (tag) ->
            tag.id = tag.name
            tag
          more: (page * response.perPage < response.total)
      initSelection: (element, callback) =>
        tags = _.map element.val().split(window.HeraclesAdmin.options.tagDelimiter), (tag) -> {id: tag, name: tag}
        callback tags
      # Format the dropdown
      formatResult: (tag) ->
        """
          <div class="select2-result__primary">
            #{tag.name}#{formatTagSelection(tag)}
          </div>
        """
      # Don't try to escape markup since we're returning HTML
      escapeMarkup: (m) -> m
      # Format the display value when selected
      formatSelection: (tag) ->
        """
          <div class="select2-result__primary">
            #{tag.name}
          </div>
        """

  render: ->
    return `<div className="fields-tags">
      <label className="fields-tags__label">Page tags</label>
      <input type="hidden" name="page[tag_list]" className="field-select2 fields-tags__input" defaultValue={this.props.tags} ref="fieldTagsInput" />
    </div>`
