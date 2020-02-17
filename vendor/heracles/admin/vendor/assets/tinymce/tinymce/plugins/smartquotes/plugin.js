
tinymce.PluginManager.add('smartquotes', function(editor) {

	function convert(e) {
		rootNodes = editor.dom.select("body > *");
		for (var i = 0; i < rootNodes.length; i++) {
			var el = rootNodes[i];
			var contentEditable = editor.dom.getAttrib(el, "contenteditable");
			if (contentEditable !== "false") {
				convertBlock(el);
			}
		}
	}

	  // Converts the quotes in the given element to smart quotes.
  function convertBlock(el) {

    // If there are less than 2 characters, we don't have enough to go on.
    if (el.innerText < 2) return;

    var previous, current, next, data, html = '', getNextChar,
      regularSingle = "'",
      regularDouble = '"',
      smartSingleLeft = String.fromCharCode(8216),  // aka - open curly single quote
      smartSingleRight = String.fromCharCode(8217),   // aka - close curly single quote
      smartDoubleLeft = String.fromCharCode(8220),  // aka - open curly double quote
      smartDoubleRight = String.fromCharCode(8221),   // aka - close curly double quote
      isDigit = function(c) { return /\d/.test(c); },
      isChar = function(c) { return /\w/.test(c); },
      isSpace = function(c) { return c === String.fromCharCode(160) || c === String.fromCharCode(32); },
      isStartChar = function(c) { return isSpace(c) || c === '('; },
      isEndChar = function(c) { return isSpace(c) || c === null || c === ';' || c === ')' || c == '.' || c === '!' || c === ',' || c === '?' || c === ':'; },
      isNonSpace = function(c) { return !isSpace(c); },
      isDouble = function(c) { return c === regularDouble || c === smartDoubleLeft || c === smartDoubleRight; },
      isSingle = function(c) { return c === regularSingle || c === smartSingleLeft || c === smartSingleRight; },
      bookmark = tinymce.activeEditor.selection.getBookmark();

    // Split the html into array allocations with the following criteria:
    //   html tags: starts with "<" and ends with ">"
    //   html entities: starts with "&" and ends with ";"
    //   characters: any character outside of an html tag or entity
    // So the following html:
    //   n&ce <b id="bold">test</b>
    // Would split into the following array:
    //  ['n', '&amp;', 'c', 'e', ' ', '<b id="bold">', 't', 'e', 's', 't', '</b>'];
    data = el.innerHTML.match(/(<("[^"]*"|'[^']*'|[^'">])*>|&.*;|.)/g);

    // Searches through the `data` array from the given index a given number of
    // characters forward or backward and returns the found character.
    getNextChar = function(data, fromIndex, nCharacters) {
      var dLength = data.length,
        addWith = nCharacters < 0 ? -1 : 1;

      return (function getChar(data, fromIndex, nCharacters) {
        // Base case - did we move outside of the bounds of the data array?
        if (fromIndex < 0 || fromIndex >= dLength) return null;

        var next = data[fromIndex + addWith];

        // If we find a character and we have moved through the
        // nCharacters, then the recursion is done.
        if (next && next.length == 1) {
          nCharacters += (addWith * -1);
          if (!nCharacters) return next;
        }
        return getChar(data, fromIndex + addWith, nCharacters);

      })(data, fromIndex, nCharacters);
    };

    for (var pos = 0; pos < data.length; pos++) {
    	val = data[pos];
      // Convert space entities so that they can be processed as normal characters.
      if (val == '&nbsp;') val = data[pos] = ' ';

      // If the val is a character, then examine the surroundings
      // and convert smart quotes, if necessary.
      if (val.length == 1) {

        // Keep convenience pointers to the previous, current and next characters.
        previous = getNextChar(data, pos, -1);
        current = val;
        next = getNextChar(data, pos, 1);

        switch (current) {

          /**
           * Conversion Rules:
           * ----------------
           *
           * START: assign smart left/open
           *   [SPACE|START_PARENTHESIS]'word
           *   [SPACE|START_PARENTHESIS]"word
           *
           * END: assign smart right/close
           *   word'[SPACE|SEMICOLON|COLON|PERIOD|COMMA|EXCLAMATION_MARK|QUESTION_MARK|END_PARENTHESIS|NULL]
           *   word"[SPACE|SEMICOLON|COLON|PERIOD|COMMA|EXCLAMATION_MARK|QUESTION_MARK|END_PARENTHESIS|NULL]
           *
           * PLURAL_CONTRACTION: assign smart right/close
           *   Matt's
           *   can't
           *   O'Reilly
           *
           * YEAR_ABBREVIATION: assign smart right/close
           *   [SPACE|NULL]'99[SPACE|SEMICOLON|COLON|PERIOD|COMMA|EXCLAMATION_MARK|QUESTION_MARK|END_PARENTHESIS|NULL]
           *
           * NESTED_START: assign smart left/open
           *   [SPACE|NULL]"[SPACE]'word
           *
           * NESTED_END: assign smart left/open
           *   word'[SPACE]"[SPACE|SEMICOLON|COLON|PERIOD|COMMA|EXCLAMATION_MARK|QUESTION_MARK|END_PARENTHESIS|NULL]
           *
           * Notes:
           *  - The following will not be converted correctly - ...word 'Til Death - it should
           *  get a right/close smart quote, but will get a left/open.
           *  - Distinguishing between year abbreviation, '99, and when to use an open single quote
           *  could fail if a single quoted region starts with a double digit number - '99 problems'
           *  - Since they are a rare case and there are many permutations, measurements are not being
           *  handled (6'8", 6' 8", 6', 8").
           */

          // Convert smart single quotes to non-smart quote and fall through to single quote
          // handling, in case the context has changed and we need to update the smart quote.
          // case smartSingleLeft:
          // case smartSingleRight:
          //   current = regularSingle;
          case regularSingle:
            // YEAR_ABBREVIATION - look 2 ahead to see if there are two digits in a row - not fool proof
            if ((previous === null || isSpace(previous)) && isDigit(next) && isDigit(getNextChar(data, pos, 2)) && isEndChar(getNextChar(data, pos, 3)))
              current = smartSingleRight;
            // START
            else if (previous === null || (isStartChar(previous) && isNonSpace(next)))
              current = smartSingleLeft;
            // END
            else if (next === null || (isNonSpace(previous) && isEndChar(next)))
              current = smartSingleRight;
            // PLURAL_CONTRACTION
            else if (isChar(previous) && isChar(next))
              current = smartSingleRight;
            break;

          // Convert smart double quotes to non-smart quote and fall through to double quote
          // handling, in case the context has changed and we need to update the smart quote.
          // case smartDoubleLeft:
          // case smartDoubleRight:
          //   current = regularDouble;
          case regularDouble:
            // NESTED_END
            if (isEndChar(next) && isSpace(previous) && isSingle(getNextChar(data, pos, -2)))
              current = smartDoubleRight;
            // START
            else if (previous === null || (isStartChar(previous) && isNonSpace(next)))
              current = smartDoubleLeft;
            // END
            else if (next === null || (isNonSpace(previous) && isEndChar(next)))
              current = smartDoubleRight;
            // NESTED_START
            else if ((previous === null || isSpace(previous)) && (isSpace(next) && isSingle(getNextChar(data, pos, 1))))
              current = smartDoubleLeft;
            break;
        }
        if (current !== null) data[pos] = current;
      }
    }

    editor.dom.setHTML(el, data.join(''));
    tinymce.activeEditor.selection.moveToBookmark(bookmark);
  }

	// Add appropriate listeners for resizing content area
	editor.on("change setcontent keyup", convert);
});
