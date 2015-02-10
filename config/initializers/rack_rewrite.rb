WheelerCentre::Application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  r301 '/videos', '/broadcasts'
  r301 '/dailies', '/notes'
  r301 '/search/tag_cloud', '/topics'
  r301 '/events/presenters', '/people'
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
  r301 '/projects/wheeler-centre-hot-desk-fellowships-2014', '/projects/projects/wheeler-centre-hot-desk-fellowships-2014'
  r301 '/projects/wheeler-centre-hot-desk-fellowships-2013', '/projects/projects/wheeler-centre-hot-desk-fellowships-2013'
  r301 '/sitemap.xml', 'http://wheeler-centre-heracles.s3.amazonaws.com/sitemaps/sitemap.xml.gz'
end