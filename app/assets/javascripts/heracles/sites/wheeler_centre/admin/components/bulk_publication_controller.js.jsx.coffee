###* @jsx React.DOM ###

"use strict"

formatTagSelection = (tag) ->
  """
    <div class="select2-result__primary">
      #{tag.name}
    </div>
  """

HeraclesAdmin.views.bulkPublicationController = ($el, el) ->
  search = $el.find("#bulk-publication-search input")

  $(search).select2
    tags: true
    multiple: true
    separator: window.HeraclesAdmin.options.tagDelimiter
    tokenSeparators: [window.HeraclesAdmin.options.tagDelimiter]

    escapeMarkup: (m) -> m
    initSelection: (element, callback) =>
      tags = _.map element.val().split(window.HeraclesAdmin.options.tagDelimiter), (tag) -> {id: tag, name: tag}
      callback tags
    createSearchChoice: (term, data) ->
      matches = $(data).filter -> this.text?.localeCompare(term) is 0
      if (matches.length is 0)
        id: term,
        name: term
        count: 0
    formatResult: (tag) ->
      formatTagSelection tag
    formatSelection: (tag) ->
      formatTagSelection tag

    ajax:
      url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/tags"
      dataType: "json"

      data: (term, page) ->
        q: term
        page: page

      transport: (params) ->
        callback = params.success
        params.success = (data, textStatus, jqXHR) ->
          callback {
            data: data,
            perPage: jqXHR.getResponseHeader('Per-Page')
            total: jqXHR.getResponseHeader('Total')
          }, textStatus, jqXHR
        $.ajax(params)

      results: (response, page, xhr) ->
        results: _.map response.data.tags, (tag) ->
          tag.id = tag.name
          tag
        more: (page * response.perPage < response.total)

  $(".select2-input").on 'keyup', (e) ->
    if e.keyCode == 13
      $("#bulk-publication-search").submit()

  $(".bulk-publication__actions-item--completed").each ->
    $el = $(@)
    setTimeout (->
      $el.css backgroundColor: "#ffff99"
    ), 1000
