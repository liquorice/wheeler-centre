#Notes on importing the Legacy content from Blueprint classes

Legacy Blueprint pages mapped to `Page`
- Page
- FaqPage (lists FAQ questions)
- PslPage (lists about-us/people)
- CttPage (Contact us page)
- DbyPage (Media page)
- DirPage - lists partners at /residents, but has its own introductory copy


Types I've put to the side for the moment:
`FaqQuestion` - Unsure of how to deal with FAQ questions - create them as a seperate content type and then make them insertables (the generic page insertable maybe)? Do they even need to be separate content?
`SchPage` - has "search" as its slug, only one example in data without any real content in it. Will map to our specific search page?
`CendirPage` - has "resources" as its slug, only one example in data
`TumPage` - has slugs under the "projects" sections eg projects/criticism-now/criticism-in-the-digital-age, seems to represent reviews or critical feedback? Many examples
`CenvidPage` - represents /videos, which we will replace with /recordings, most probably. Only one example in data
`CenmemPage` - represents /members, and shows a login form. which we will probably be replaced in the process of setting up either Discourse or Disqus? Only one example in data
`CmtPage` - represents /comments, and shows a list of comments. Likely to be replaced with Discourse/Disqus?