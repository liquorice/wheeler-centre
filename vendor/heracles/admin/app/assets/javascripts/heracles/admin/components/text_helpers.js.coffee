class TextHelpers
  capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)
  humanize: (string, capitalize) ->
    output = string.replace(/_/, " ")
    if capitalize then @capitalize output else output

# Make available
HeraclesAdmin.helpers.text = new TextHelpers()
