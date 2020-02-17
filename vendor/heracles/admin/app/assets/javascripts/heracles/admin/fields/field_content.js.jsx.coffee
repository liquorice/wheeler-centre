#= require jquery
#= require react

#= require heracles/admin/components/available_fields
#= require heracles/admin/components/field_content_editor
#= require heracles/admin/components/available_insertables
#= require heracles/admin/fields/field_content_button
#= require heracles/admin/fields/field_content_inline_editor
#= require heracles/admin/fields/field_header
#= require heracles/admin/fields/field_fallback
#= require heracles/admin/fields/field_errors

###* @jsx React.DOM ###

FieldContent = React.createClass
  mixins: [FieldMixin]
  propTypes:
    value: React.PropTypes.string
  getInitialState: ->
    field: @props.field
    value: @props.value
    buttons: @getInitialButtonOptions()
  componentDidMount: ->
    @editor = new FieldContentEditor @getDOMNode(), @handleChange, @handleButtonState, @handleToolbarPosition
    @onWindowResize()
    $(window).on "resize", @onWindowResize

  onWindowResize: (e) ->
    # Cache the height of the block controls
    if @refs?.blockControls?
      $blockControls = $(@refs.blockControls.getDOMNode())
      bcHeight = $blockControls.height()
      bcWidth = $blockControls.width()
    @blockControlsDimensions =
      height: bcHeight || 0
      width:  bcWidth || 0

  # Passed to the FieldContentEditor instance and called on content changes events
  handleChange: (content) ->
    unless _.isEmpty(content) && _.isEmpty(@state.value)
      # Override only the field data that changes
      newField = _.extend {}, @state.field, value: content
      @props.updateField @state.field.field_name, newField
      @setState
        field: newField
        value: content
  # Passed to the FieldContentEditor instance called on nodeChange
  handleButtonState: (e) ->
    newButtonState = _.extend {}, @state.buttons
    $.map @state.buttons, (button, type) =>
      button?.active = @editor?.tagIsOrDescendsFrom(e, button.tag)
      # Set any data attrs (like link data) in the button itself
      # TODO this should probably be abstracted, feels dirty
      if button.active is true and type is "link"
        element = e.element
        button.data =
          href: element.href
          title: element.title
          target: element.target
          assetID: element.dataset.assetId
          pageID:  element.dataset.pageId
    @setState buttons: newButtonState # Update the button state

  # Position the inline toolbar and show it
  handleToolbarPosition: (rect) ->
    if @refs?.inlineControls?
      if rect
        @setState showInlineControls: true
        offset = 20
        $controls = $(@refs.inlineControls.getDOMNode())
        # Account for the height of the blockControls and the inlineControls
        topPosition = (@blockControlsDimensions.height + rect.top - $controls.height() - offset)
        # Account for the width of the range and the width of the inlineControls
        leftPosition = (rect.left + (rect.width / 2) - ($controls.width() / 2) - 5)
        $controls.css
          top: topPosition
          left: leftPosition
      else
        @setState showInlineControls: false

  # Passed to the <FieldContentButtons/> which passes itself back onClick
  handleButtonClick: (fieldControlButton) ->
    buttonType = fieldControlButton.props.type
    # Send the correct command to the editor
    @editor.onButtonClick buttonType, @state.buttons[buttonType]?.active

  # Callback form the inline editors
  handleInlineEditor: (type, data) ->
    if type is "link"
      # Reformat the data for setLinkData method
      linkData =
        href: data.href
        title: data.title
        target: data.target
        "data-asset-id": data.assetID if data.assetID
        "data-page-id":  data.pageID if data.pageID
      @editor?.setLinkData linkData
    # Hide the inline controls
    @setState showInlineControls: false

  # Helpers
  getInitialButtonOptions: ->
    buttons =
      dropdowns_headings: false
      bold:
        tag: "strong"
        enabled: false
        active: false
        inline: true
      italic:
        tag: "em"
        enabled: false
        active: false
        inline: true
      ul:
        tag: "ul"
        enabled: false
        active: false
        inline: false
      ol:
        tag: "ol"
        enabled: false
        active: false
        inline: false
      quote:
        tag: "blockquote"
        enabled: false
        active: false
        inline: false
      hr:
        tag: "hr"
        enabled: false
        active: false
        inline: false
      link:
        tag: "a"
        enabled: false
        active: false
        inline: true
      h1:
        tag: "h1"
        enabled: false
        active: false
        dropdown: "headings"
      h2:
        tag: "h2"
        enabled: false
        active: false
        dropdown: "headings"
      h3:
        tag: "h3"
        enabled: false
        active: false
        dropdown: "headings"
      h4:
        tag: "h4"
        enabled: false
        active: false
        dropdown: "headings"
      h5:
        tag: "h5"
        enabled: false
        active: false
        dropdown: "headings"
      dropdowns_insertables: false

    buttonOptions = if @props.field.buttons? then @props.field.buttons else "h1,h2,h3,h4,h5,bold,italic,ul,ol,quote,hr,link,headings,insertables"
    for button in buttonOptions.split(",")
      if buttons[button]? then buttons[button]?.enabled = true
      if buttons["dropdowns_" + button]? then buttons["dropdowns_" + button] = true
    return buttons

  # Iterate over the this.state.buttons to build up the available controls
  # Passes off to FieldContentButton for individual button rendering
  buildBlockControls: ->
    # Fields can specify if button should be included. We determine them in the
    # order of with, without, and disable. Which is why this is so awkward
    if @props.field.field_config.field_disable_buttons? and @props.field.field_config.field_disable_buttons
      return "" unless @props.field.field_config.field_with_buttons? || @props.field.field_config.field_without_buttons?

    availableButtons = @state.buttons

    # Include `field_with_buttons`
    if @props.field.field_config.field_with_buttons? and @props.field.field_config.field_with_buttons.length > 0
      _.each availableButtons, (button, type) =>
        unless type.match(/dropdowns_/) || _.contains @props.field.field_config.field_with_buttons, type
          delete availableButtons[type]
    # Exclude `field_without_buttons`
    else if @.props.field.field_config.field_without_buttons?
      _.each availableButtons, (button, type) =>
        unless type.match(/dropdowns_/) || !_.contains @props.field.field_config.field_without_buttons, type
          delete availableButtons[type]
    # Bail out if `disable_insertables`
    else if @props.field.field_config.field_disable_buttons?
      return ""

    _this = @
    buttons = _.map availableButtons, (button, type) ->
      # Match "dropdowns_#{type_of_dropdown}" and collect their buttons manually
      if type.match(/dropdowns_/) and type
        groupName = type.match(/dropdowns_(.+)/)[1]
        return if groupName is "insertables" and _this.props.field.field_config.field_disable_insertables
        label = groupName.charAt(0).toUpperCase() + groupName.slice(1)
        # Special case insertables
        if groupName is "insertables"
          insertables = HeraclesAdmin.availableInsertables.list()
          # Fields can specify with/without/disabled insertable
          # We need to sort them out here
          # Include `field_with_insertables`
          if _this.props.field.field_config.field_with_insertables? and _this.props.field.field_config.field_with_insertables.length > 0
            insertables = _.filter insertables, (insertable) -> _.contains _this.props.field.field_config.field_with_insertables, insertable.type
          # Exclude `field_without_insertables`
          else if _this.props.field.field_config.field_without_insertables?
            insertables = _.filter insertables, (insertable) -> !_.contains _this.props.field.field_config.field_without_insertables, insertable.type
          # Bail out if `disable_insertables`
          else if _this.props.field.field_config.field_disable_insertables?
            return
          children = _.compact _.map insertables, (insertable) ->
            type = "insertable-#{insertable.type}"
            return `<FieldContentButton key={type} type={type} icon={insertable.icon} active={false} label={insertable.label} handleButtonClick={_this.handleButtonClick}/>`
        else
          # Collect the children and remove if falsey
          children = _.compact _.map _this.state.buttons, (childButton, childType) ->
            if childButton.dropdown is groupName
              return `<FieldContentButton key={childType} type={childType} active={childButton.active} handleButtonClick={_this.handleButtonClick}/>`
        if children.length > 0
          return `<div key={type} className={"field-content-editor__control-group " + type}>
            <div className="field-content-editor-dropdown field-content-editor__control-btn">
              <span className="field-content-editor-dropdown__label">{label}</span>
              <i className="fa fa-chevron-down"/>
              <ul className="field-content-editor-dropdown__list">
                <li>
                  {children}
                </li>
              </ul>
            </div>
          </div>`
        else
          return false
      # Handle the normal buttons
      else if button.enabled and !button.dropdown? and button.inline != true
        return `<FieldContentButton key={type} type={type} active={button.active} handleButtonClick={_this.handleButtonClick}/>`
    button = _.compact buttons
    `<div className="field-content-editor__controls" ref="blockControls">{buttons}</div>`

  buildInlineControls: ->
    # Fields can specify if button should be included. We determine them in the
    # order of with, without, and disable. Which is why this is so awkward
    if @props.field.field_config.field_disable_buttons? and @props.field.field_config.field_disable_buttons
      return "" unless @props.field.field_config.field_with_buttons? || @props.field.field_config.field_without_buttons?

    availableButtons = @state.buttons
    # Include `field_with_buttons`
    if @props.field.field_config.field_with_buttons? and @props.field.field_config.field_with_buttons.length > 0
      _.each availableButtons, (button, type) =>
        unless type.match(/dropdowns_/) || _.contains @props.field.field_config.field_with_buttons, type
          delete availableButtons[type]
    # Exclude `field_without_buttons`
    else if @.props.field.field_config.field_without_buttons?
      _.each availableButtons, (button, type) =>
        unless type.match(/dropdowns_/) || !_.contains @props.field.field_config.field_without_buttons, type
          delete availableButtons[type]
    # Bail out if `disable_insertables`
    else if @props.field.field_config.field_disable_buttons?
      return ""

    # Construct the buttons
    _this = @
    buttons = []
    editors = []
    _.each availableButtons, (button, type) ->
      if button.enabled and !button.dropdown? and button.inline is true
        buttons.push `<FieldContentButton key={type} type={type} active={button.active} handleButtonClick={_this.handleButtonClick}/>`
        if button.active and button.data?
          editors.push `<FieldContentInlineEditor type={type} data={button.data} callback={_this.handleInlineEditor}/>`
    if @state.showInlineControls
      `<div className="field-content-editor__inline-controls" ref="inlineControls">
        {buttons}
        {editors}
      </div>`
    else
      `<div className="field-content-editor__inline-controls field-content-editor__inline-controls--hidden" ref="inlineControls"></div>`

  formatFallback: ->
    if @state.field.field_config.field_fallback?.value?
      @state.field.field_config.field_fallback?.value

  render: ->
    value = @state.value
    `<div className={this.displayClassName("field-content")}>
        <FieldHeader label={this.state.field.field_config.field_label} name={this.state.field.field_name} hint={this.state.field.field_config.field_hint} required={this.state.field.field_config.field_required}/>
        <div className="field-main">
          <div className="field-content-editor">
            {this.buildInlineControls()}
            {this.buildBlockControls()}
            <textarea defaultValue={value}/>
          </div>
          <FieldFallback field={this.state.field.field_config.field_fallback} content={this.formatFallback()}/>
        </div>
        <FieldErrors errors={this.state.field.errors}/>
      </div>`



# Register as available
HeraclesAdmin.availableFields.add
  editorType: "content"
  formatProps: (data) ->
    key: data.key
    newRow: data.newRow
    updateField: data.updateField
    field: data.field
    value: data.field.value
  component: FieldContent
