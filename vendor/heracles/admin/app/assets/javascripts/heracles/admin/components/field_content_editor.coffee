#= require jquery
#= require lodash
#= require react

# Use the jQuery-optimized tinymce, and bundle a theme and some plugins
#= require tinymce.jquery
#= require tinymce/themes/basic
#= require tinymce/plugins/autoresize
#= require tinymce/plugins/paste
#= require tinymce/plugins/smartquotes

#= require heracles/admin/components/available_insertables
#= require heracles/admin/insertables/insertable_image
#= require heracles/admin/insertables/insertable_gallery
#= require heracles/admin/insertables/insertable_video
#= require heracles/admin/insertables/insertable_audio
#= require heracles/admin/insertables/insertable_code
#= require heracles/admin/insertables/insertable_savedsearch
#= require heracles/admin/insertables/insertable_button


"use strict"

#
# FieldContentEditor
#
# Handles the TinyMCE instance for each `content` field.
#

class window.FieldContentEditor
  constructor: (@el, @updateParent, @handleButtonState, @handleToolbarPosition) ->
    @$el = $(@el)
    @$doc = $(document)
    @placeholderSelected = false

    # Set a unique ID
    @id = tinymce.DOM.uniqueId @el[0]
    @$el.find("textarea").attr("id", @id);
    # Attach TinyMCE
    @tinymce = tinyMCE.createEditor @id,
      autoresize_max_height: 600
      noneditable_editable_class: "insertable"
      object_resizing: false
      plugins: "paste,autoresize"
      selector: "textarea"
      setup: @setupEditor
      theme: "basic"
      valid_elements: "-p,br,ol,ul,li,hr,-a[href|title|target|data-asset-id|data-page-id],-strong/b,-em/i,h1,h2,h3,h4,h5,span,blockquote,*[!contenteditable|insertable|value|class]"
    @tinymce.render()

  setupEditor: (editor) =>
    editor.on "init", @onInitEditor
    editor.on "SetContent", @onSetContent
    editor.on "KeyUp", @onKeyUp
    editor.on "KeyDown", @onKeyDown
    editor.on "KeyPress", @onKeyPress
    editor.on "Undo", @onUndo
    editor.on "PastePostProcess", @onPastePostProcess
    editor.on "click", @onClick
    editor.on "change", @onChange
    editor.on "nodeChange", @onNodeChange

  onInitEditor: (e) =>
    @activateInsertables()

  onSetContent: (e) =>
    unless e.initial then @updateComponent()

  onUndo: (e) =>
    @tinymce.dom.select("body").innerHTML = @sanitizeOutput(@tinymce.getContent())
    @activateInsertables()


  onKeyDown: (e) =>
    @checkIfPlaceholderSelected()
    if @placeholderSelected
      # Enter key
      if e.keyCode is 13
        e.preventDefault()
        # Inject an empty paragraph before the current node
        currentRootNode = @getCurrentRootNode()
        $(@getCurrentRootNode()).before("<p><br/></p>")

  onKeyPress: (e) =>
    @checkIfPlaceholderSelected()
    # If we're in a placeholder, then create new element and inject the new
    # content into it.
    if @placeholderSelected and (e.keyCode < 37 || e.keyCode > 40)
      e.preventDefault()
      character = String.fromCharCode(e.which || e.keyCode)
      # Inject an empty paragraph before the current node
      currentRootNode = @getCurrentRootNode()
      newNode = $("<p>#{character}</p>").insertBefore @getCurrentRootNode()
      @tinymce.selection.setCursorLocation newNode[0], 1

  onPastePostProcess: (e) =>
    @checkIfPlaceholderSelected()
    # If we're in a placeholder, handle the paste manually and inject it
    # into an empty <div>. The `valid_elements` rules should take care of
    # cleaning it up.
    if @placeholderSelected
      e.preventDefault()
      # # Inject an empty paragraph before the current node
      currentRootNode = @getCurrentRootNode()
      newNode = $("<div>").html(e.node.innerHTML).insertBefore @getCurrentRootNode()
      @tinymce.selection.setCursorLocation newNode[newNode.length - 1], 0

  onKeyUp: (e) =>
    @updateComponent()
    @injectEmptyEndParagraph()

  onClick: (e) =>
    @tinymce.execCommand('mceAutoResize')
    @setToolbarPosition()

  onChange: (e) =>
    @updateComponent()
    @matchInsertablesPlaceholderPairs()
    @injectEmptyEndParagraph()

  onNodeChange: (e) =>
    @matchInsertablesPlaceholderPairs()
    @handleButtonState(e) # Tell the <FieldContent/> component to update the button state
    @injectEmptyEndParagraph()
    @setToolbarPosition()
    @checkIfPlaceholderSelected(e)

  #
  # onButtonClick
  # When an insertable selection from the dropdown has been clicked
  #

  onButtonClick: (button, previousActiveState) ->
    if button is "bold"
      @tinymce.execCommand "bold", false
    else if button is "italic"
      @tinymce.execCommand "italic", false
    else if button.match /h[0-5]/
      @tinymce.execCommand("formatBlock", false, button)
    else if button is "ul"
      @tinymce.execCommand("InsertUnorderedList", false)
    else if button is "ol"
      @tinymce.execCommand("InsertOrderedList", false)
    else if button is "quote"
      @tinymce.execCommand("formatBlock", false, "blockquote")
    else if button is "hr"
      # @tinymce.execCommand("InsertHorizontalRule", false)
      div = $("<div class='hr' contenteditable='false'><hr/></div>")
      @tinymce.dom.insertAfter div[0], @getCurrentRootNode()
    else if button is "link"
      if previousActiveState is true
        @tinymce.formatter.remove("link")
      else
        @tinymce.formatter.apply("link", {href: ""})
      setTimeout(=>
        @setToolbarPosition()
      , 4)
    else if button.match /^insertable-/
      insertableType = button.slice(button.indexOf("-") + 1)
      # Setup hook for React component
      div = $("<div contenteditable='false' insertable='#{insertableType}' value='{}'>")
      @tinymce.dom.insertAfter div[0], @getCurrentRootNode()
      # Tell the insertables to activate (through React)
      @activateInsertables()

  getCurrentRootNode: ->
    target = if @tinymce.selection.getSel().type is "None"
      _.last @tinymce.dom.select("body > *")
    else
      @tinymce.selection.getNode()
    @getRootParentNode target

  # Recursively find the parent node just inside the <body>
  getRootParentNode: (node) ->
    if !node.parentNode?
      return @tinymce.dom.select("body > *")[0]
    else if node.parentNode.nodeName is "BODY"
      return node
    else
      @getRootParentNode node.parentNode

  getPreviousRootNode: ->
    rootNodes = @tinymce.dom.select("body > *")
    currentIndex = _.indexOf rootNodes, @getCurrentRootNode()
    rootNodes = rootNodes.slice(0, currentIndex).reverse()
    previousParagraph = _.find rootNodes, (node) ->
      return node.tagName == "P"
    return previousParagraph

  tagIsOrDescendsFrom: (e, targetTagName, returnElement = false) ->
    if e.element.tagName.toLowerCase() is targetTagName
      return if returnElement then e.element else true

    for parent in e.parents
      if parent.tagName.toLowerCase() is targetTagName
        return if returnElement then e.element else true

    return false

  # We need to maintain an empty paragraph at the end of the editor all the time
  injectEmptyEndParagraph: ->
    lastRootElement = _.last @tinymce.dom.select("body > *")
    if lastRootElement.nodeName isnt "P"
      content = lastRootElement.innerHTML
      content = content.replace(/&nbsp;/g, " ")
      content = content.trim()
      # Unless content is already a blank p, inject one.
      unless content is "" or content is '<br data-mce-bogus="1">' or content is '<br>'
        newElement = $("<p><br data-mce-bogus='1'></p>")
        @tinymce.dom.insertAfter newElement[0], lastRootElement


  # Parse the TinyMCE DOM and trigger any insertables to render as React
  # components
  activateInsertables: ->
    insertableNodes = @tinymce.dom.select("[insertable]:not([active])")
    _.each insertableNodes, (node) ->
      $node = $(node)
      $node.empty()
      # We need to wrap the insertables in paragraphs with <br/> tags to make
      # movement around the editor work correctly
      $node.before("<div class='heracles-placeholder'><br></div>")
      type = $node.attr "insertable"
      value = JSON.parse($node.attr "value")
      insertable = HeraclesAdmin.availableInsertables.get type
      # Render the insertable
      # Pass in container so we can set its `value` attribute when changing data
      React.renderComponent(
        insertable.display({type: type, value: value, container: node}), node
      )
      # TinyMCE won't assign the `active` attribute to the content, so we
      # don't need to remove it manually.
      $node.attr "active", "true"
    @tinymce.execCommand('mceAutoResize')

  sanitizeOutput: (output) ->
    $output = $("<div>").append($(output))
    # Empty the insertable <div>s before saving. They get recreated on page load
    # by React anyway.
    $output.find("[insertable]").empty()
    # Remove any placeholders
    $output.find(".heracles-placeholder").remove()
    return $output.html()

  # Disable a range of default keyboard shortcuts
  disableKeyboardShortcuts: ->
     # Do nothing function
    doNothing = ->
    for i in [1..6] by 1
      @tinymce.shortcuts.add "ctrl+#{i}", "", doNothing
    @tinymce.shortcuts.add 'ctrl+7', '', doNothing
    @tinymce.shortcuts.add 'ctrl+8', '', doNothing
    @tinymce.shortcuts.add 'ctrl+9', '', doNothing

  # Tell the inline toolbar where it should be
  setToolbarPosition: ->
    selection = @tinymce.selection.getSel()
    unless selection.type is "None"
      range = selection.getRangeAt(0)
      unless range.collapsed
        return @handleToolbarPosition range.getBoundingClientRect()
    @handleToolbarPosition false

  # Handle link data from the inline editors
  setLinkData: (data) ->
    @tinymce.formatter.remove("link")
    @tinymce.formatter.apply("link", data)

  # Check if the currently selected node is a placeholder
  checkIfPlaceholderSelected: ->
    rootNode = @getCurrentRootNode()
    @placeholderSelected  = (rootNode.className is "heracles-placeholder")

  matchInsertablesPlaceholderPairs: ->
    rootNodes = @tinymce.dom.select("body > *")
    _.each rootNodes, (node, index) =>
      # Check if placeholders have matching insertables
      if node.className is "heracles-placeholder"
        nextNode = rootNodes[index + 1]
        if nextNode? and _.isEmpty(nextNode.getAttribute("insertable"))
          # Remove if empty, otherwise turn into a paragraph
          if node.innerHTML == ""
            node.remove()
          else
            p = $("<p>")
            @tinymce.dom.replace p[0], node, true
      # Check if insertables have a placeholder
      else unless !nextNode? and _.isEmpty(node.getAttribute("insertable"))
        prevNode = rootNodes[index - 1]
        unless prevNode.className is "heracles-placeholder"
          $(node).before("<div class='heracles-placeholder'><br></div>")


  # Send the data back to <FieldContent/>
  updateComponent: ->
    @updateParent @sanitizeOutput(@tinymce.getContent())
