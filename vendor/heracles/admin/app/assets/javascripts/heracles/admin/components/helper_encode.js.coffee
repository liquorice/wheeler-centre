"use strict"

HeraclesAdmin.helpers.htmlEncode = (value) -> $('<div/>').text(value).html()

HeraclesAdmin.helpers.htmlDecode = (value) -> $('<div/>').html(value).text()
