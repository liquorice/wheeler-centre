#= require lodash
#= require react
#= require jquery
#= require select2

#= require heracles/admin/lightboxes/lightbox

###* @jsx React.DOM ###


SavedsearchSelectorConditionLightbox = React.createClass

  componentDidUpdate: ->
    @_keepUpdated()

  componentDidMount: ->
    @_keepUpdated()

  render: ->
    condition = @props.condition

    # Define label title
    labelTitle = switch condition.condition_type
      when 'tag'   then 'Tags contain'
      when 'page'  then 'Page type is'
      when 'field' then 'The field'

    # Delete button
    deleteButton = `<i onClick={this.props._handleDestroy} data-index={this.props.index} className='savedsearch-selector__right savedsearch-selector__button fa fa-close'></i>`

    # Define field name
    askField = if condition.condition_type == 'field'
      @renderSelect 'field', condition.field, @props.searchableFields

    # Define matching type list
    askMatch = if condition.condition_type == 'field'
      @renderSelect 'match_type', condition.match_type, @props.fieldsMatching?[condition.field]

    # Define value input/select
    askValue = switch condition.condition_type
      when 'page' then @renderSelect 'match_value', condition.match_value, @props.pageTypes
      else @renderInput 'match_value', condition.match_value, condition.condition_type

    # Template
    classString = 'savedsearch-selector__row savedsearch-selector__row--' + condition.condition_type
    `<li className={classString}>
      {deleteButton}
      <label className='savedsearch-selector__label savedsearch-selector__label--condition'>{labelTitle}</label>
      {askField}
      {askMatch}
      {askValue}
    </li>`

  renderInput: (name, value, type) ->
    `<input type='text' name={name} value={value} data-index={this.props.index} data-type={type} onChange={this.props._handleSelect} className='savedsearch-selector__field field-text-input field-small field-size--medium' />`

  renderSelect: (name, value, options) ->
    options = _.map options, (option) ->
      `<option value={option.type}>{option.name}</option>`
    `<select name={name} value={value} data-index={this.props.index} onChange={this.props._handleSelect} className='field-select2 field-select2--small  savedsearch-selector__drop'>
      {options}
    </select>`

  _keepUpdated: ->
    _this = @

    _.each $(@getDOMNode()).find('select'), (item) ->
      $(item).select2 'val', _this.props.condition[item.name]



formatTagSelection = (tag) ->
  if tag.count > 0
    """<span class="field-mono">&nbsp;(#{tag.count})</span>"""
  else if tag.count is 0
    """<span class="field-mono">&nbsp;(new)</span>"""
  else
    ""


SavedsearchSelectorConditionsLightbox = React.createClass

  # Use DidUpdate rather than DidMount to predict new component creation and initialize Select2
  componentDidUpdate: () ->
    _this = @

    drops = $(@getDOMNode()).find('select')
    _.each drops, (drop) ->
      # Prevents multiple initializations
      if $(drop).data('select2') == undefined
        $(drop).select2
          dropsdownAutoWidth : true
        $(drop).on 'change', (e) ->
          _this.props._handleSelect e

    tags = $(@getDOMNode()).find('input[data-type="tag"]')
    _.each tags, (tag) ->
      # Prevents multiple initializations
      if $(tag).data('select2') == undefined
        $(tag).select2
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
      $(tag).on 'change', (e) ->
        _this.props._handleSelect e

  render: ->
    _this = @

    createItem = (condition, index) ->
      `<SavedsearchSelectorConditionLightbox index={index} condition={condition} pageTypes={_this.props.pageTypes} pageTags={_this.props.pageTags} searchableFields={_this.props.searchableFields} fieldsMatching={_this.props.fieldsMatching} _handleSelect={_this.props._handleSelect} _handleDestroy={_this.props._handleDestroy} />` if condition != undefined
    `<ul>{this.props.conditions.map(createItem)}</ul>`


SavedsearchSelectorLightbox = React.createClass

  getDefaultProps: ->
    saved_search :
      theme      : 'default'
      combination_type  : 'any'
      conditions : []
      page_tags         : []
      page_types        : []
      searchable_fields : []
      fields_matching   : []

  getInitialState: ->
    theme      : @props.saved_search.theme
    combination_type  : @props.saved_search.combination_type
    conditions : @props.saved_search.conditions

  componentDidMount: ->
    _this = @

    conditionAdd = $(@refs.conditionAdd.getDOMNode())
    conditionAdd.select2
      placeholder: 'Select condition to add'
      minimumResultsForSearch: -1
      dropdownAutoWidth : true

    outerSelect = $(@getDOMNode()).find('select[data-type="outer"]')
    outerSelect.select2
      minimumResultsForSearch: -1
      dropdownAutoWidth: true
    outerSelect.on 'change', (e) ->
      _this._handleChange e

    $.ajax
      url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/saved_search_fields"
      dataType: "json"
      contentType: "application/json"
      success: (data) ->
        nextThemes = ['default'].concat data.themes
        _this.setState page_types: data.page_types, searchable_fields: data.searchable_fields, fields_matching: data.fields_matching, themes: nextThemes
        $(_this.refs.themeSelect.getDOMNode()).select2 'val', _this.state.theme

    $.ajax
      url: "#{HeraclesAdmin.baseURL}api/sites/#{HeraclesAdmin.siteSlug}/tags"
      dataType: "json"
      contentType: "application/json"
      success: (data) ->
        _this.setState page_tags: data

  render: ->

    themeOptions = _.map @state.themes, (theme) ->
      formattedName = theme.replace(/_/gi, " ")
      formattedName = formattedName.charAt(0).toUpperCase() + formattedName.slice(1)
      `<option value={theme}>{formattedName}</option>`

    `<div className='savedsearch-selector'>
      <p className='lightbox-title'>Saved search conditions</p>
      <div className='savedsearch-selector__form'>

        <div className='savedsearch-selector__list'>

          <div className='savedsearch-selector__options'>
            <div className="field-associated-pages__form field-addon savedsearch__add">
              <select ref='conditionAdd' className='field-select2 field-select2--small field-addon-input'>
                <option></option>
                <option value='tag'>Tags</option>
                <option value='page'>Page type</option>
                <option value='field'>Field match</option>
              </select>
              <button className="field-addon-button button button--small button--soft" onClick={this._onAddConditionClick}>Add condition</button>
            </div>

              <label className='savedsearch-selector__label savedsearch-selector__label--match'>Show content that matches</label>
              <select data-type='outer' ref='matchingChange' value={this.state.combination_type} name='combination_type' className='field-select2--small field-select2 savedsearch-selector__drop'>
                <option value='any'>any</option>
                <option value='all'>all</option>
              </select>
              of below:
          </div>

          <SavedsearchSelectorConditionsLightbox conditions={this.state.conditions} pageTypes={this.state.page_types} pageTags={this.state.page_tags} searchableFields={this.state.searchable_fields} fieldsMatching={this.state.fields_matching} _handleDestroy={this._handleDestroy} _handleSelect={this._handleSelect} />

          <div className='savedsearch-selector__row--theme'>
            <label className='savedsearch-selector__label'>Format results using this template</label>
            <select data-type='outer' ref='themeSelect' value={this.state.theme} name='theme' className='field-select2 field-select2--small savedsearch-selector__drop'>
              {themeOptions}
            </select>
          </div>

        </div>

        <div className='savedsearch-selector__save'>
          <a href='#' className='button button--dark' onClick={this._applyConditions}>Confirm changes</a>
        </div>

      </div>
    </div>`

  _onAddConditionClick: (e) ->
    e.preventDefault();
    @_handleAdd @refs.conditionAdd.getDOMNode().value

  # Add new conditions
  _handleAdd: (condition_type) ->
    condition = switch condition_type
      when 'field' then {
        condition_type: condition_type
        field: @state.searchable_fields[0].type
        match_type: @state.fields_matching[@state.searchable_fields[0].type][0].type
      }
      when 'page' then {
        condition_type: condition_type
        match_value: @state.page_types[0].type
      }
      else {
        condition_type: condition_type
      }

    nextConditions = @state.conditions.concat(condition)
    @setState {conditions: nextConditions}

  # Change option value
  _handleChange: (e) ->
    nextState = {}
    nextState[e.target.name] = e.target.value
    @setState nextState

  # Change condition value
  _handleSelect: (e) ->
    index = $(e.target).data('index')
    nextConditions = @state.conditions.slice()
    nextConditions[index][e.target.name] = e.target.value
    @setState {conditions: nextConditions}

  # Remove condition
  _handleDestroy: (e) ->
    index = $(e.target).data('index')
    nextConditions = @state.conditions.slice()
    # Trick for keeping select2 key values unique
    nextConditions[index] = undefined
    @setState {conditions: nextConditions}

  _applyConditions: (e) ->
    e.preventDefault()
    @props.callback {theme: @state.theme, combination_type: @state.combination_type, conditions: @state.conditions.filter (e) -> e }
    @props.api.closeLightbox(e)


# Register as available
HeraclesAdmin.availableLightboxes.add
  type: 'SavedsearchSelectorLightbox'
  component: SavedsearchSelectorLightbox
