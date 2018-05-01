WheelerCentre::Application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  r301 '/videos', '/broadcasts'
  r301 '/videos/video_podcast', '/broadcasts/podcasts/the-wheeler-centre.rss?format=video'
  r301 '/videos/audio_podcast', '/broadcasts/podcasts/the-wheeler-centre.rss?format=audio'
  r301 %r{/events/program_feed(.*)}, '/broadcasts/podcasts$1.rss'
  r301 %r{/calendar/program_feed(.*)}, '/broadcasts/podcasts$1.rss'
  r301 %r{/videos/video(.*)}, '/broadcasts$1'
  r301 '/dailies', '/notes'
  r301 '/dailies/today', '/notes'
  r301 '/dailies/yesterday', '/notes'
  r301 '/dailies/channel/quotes', '/notes'
  r301 '/dailies/channel/sounds', '/notes'
  r301 '/dailies/channel/widgets', '/notes'
  r301 '/dailies/channel/images', '/notes'
  r301 '/dailies/channel/links', '/notes'
  r301 '/dailies/channel/articles', '/notes'
  r301 %r{/dailies/post(.*)}, '/notes$1'
  r301 %r{/dailies(.*)}, '/notes$1'
  r301 '/search/tag_cloud', '/topics'
  r301 %r{/search/tag(.*)}, '/search?q=$1'
  r301 '/events/presenters', '/people'
  r301 %r{/events/presenter(.*)}, '/people$1'
  r301 %r{/events/event(.*)}, '/events$1'
  r301 '/about-us/people', '/people'
  r301 '/about-us/people/staff', '/people'
  r301 '/about-us/people/board', '/people'
  r301 '/about-us/the-wheeler-centre', '/about-us/who-we-are'
  r301 '/about-us/support-us/corporate-partnerships', '/about-us/support-us/'
  r301 '/about-us/support-us/corporate-partnerships/the-ministry-of-ideas', '/about-us/support-us/'
  r301 '/about-us/support-us/individuals', '/about-us/support-us/'
  r301 '/about-us/support-us/corporate-partnerships/sponsorship', '/about-us/support-us/'
  r301 '/about-us/support-us', '/about-us/who-funds-us/support-us'
  r301 '/about-us/support-us/individuals/conversation-starters', '/about-us/who-funds-us/support-us'
  r301 '/about-us/support-us/our-partners', '/about-us/who-funds-us/sponsors'
  r301 '/about-us/the-moat', '/events/venues/the-moat'
  r301 '/about-us/the-building-176-little-lonsdale-street', '/events/venues/the-wheeler-centre'
  r301 '/about-us/faq', '/about-us/faqs'
  r301 '/fine-print/privacy-policy', '/about-us/privacy'
  r301 '/fine-print/community-guidelines', '/about-us/community-guidelines'
  r301 '/projects/deakin-lectures-2010/presenters', '/projects/deakin-lectures-2010'
  r301 '/sitemap.xml', 'http://wheeler-centre-heracles.s3.amazonaws.com/sitemaps/sitemap.xml.gz'

  # Rewrite tracking URLs
  params_pairs = [
    ["_target", "target"],
    ["target", "target"],
    ["status", "redirect"],
    ["location", "location"],
    ["title", "title"],
    ["path", "path"],
    ["event_category", "category"],
    ["event_action", "action"],
    ["event_label", "label"],
    ["campaign_id", "campaign_id"],
    ["social_action", "action"],
    ["social_network", "network"]
  ]

  params_rewrite = params_pairs.map {|pair| "#{pair[0]}=([^&]*)" }.join("|")

  r301 %r{/_track/([\w\.]+)(.*)}, lambda { |match, rack_env|
    expected_params = params_pairs.map(&:first)
    parsed_params = Rack::Utils.parse_nested_query(rack_env["QUERY_STRING"]).select {|p|
      expected_params.include? p
    }
    updated_params = parsed_params.map {|key, value|
      updated_key = params_pairs[expected_params.index key][1]
      [updated_key, value]
    }
    "#{ENV["TRACKING_SERVER_BASE_URL"]}/#{match[1]}?#{URI.encode_www_form(updated_params)}"
  }

  rewrite /\/(.*)/, '/the-next-chapter/$1', host: "the-next-chapter.localhost"
  rewrite /\/(.*)/, '/the-next-chapter/$1', host: "the-next-chapter.wheelercentre.com"
  rewrite /\/(.*)/, '/the-next-chapter/$1', host: "next-chapter-test.wheelercentre.com"
end
