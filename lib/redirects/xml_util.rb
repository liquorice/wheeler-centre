require 'net/http'
require 'nokogiri'

heroku_data = File.open('twc_sitemap.xml')

doc = Nokogiri::XML(heroku_data)

puts doc

locs = doc.css("loc")

locs.each do |loc|
	url = loc.text
	url_components = url.split('http://wheelercentre.com')
	puts url_components[1]
end
