#=require speakingurl

"use strict"

HeraclesAdmin.helpers.slugify = (text) ->
  if text? then getSlug(text)
