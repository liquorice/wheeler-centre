// Parse time
// Convert a string of the format 1h5m45s into seconds
function parseTime(string) {
  var matches = string.match(/(?:(\d*)h)?(?:(\d*)m)?(?:(\d*)s?)/);
  var hours = parseInt(matches[1]) || 0;
  var minutes = parseInt(matches[2]) || 0;
  var seconds = parseInt(matches[3]) || 0;
  return (hours * 60 * 60) + (minutes * 60) + seconds;
}

module.exports = parseTime;
