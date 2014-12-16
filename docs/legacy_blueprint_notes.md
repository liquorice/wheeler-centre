#Notes on importing the Legacy content from Blueprint classes

Legacy Blueprint pages mapped to `Page`
- Page
- FaqPage (lists FAQ questions)
- PslPage (lists about-us/people)
- CttPage (Contact us page)
- DbyPage (Media page)
- DirPage - lists partners at /residents, but has its own introductory copy

These are the ones that for the moment I think will be covered by other aspects of the app
Types I've put to the side for the moment:
`FaqQuestion` - Don't think they need to be separate content, plan to extract them all and insert into the FAQ page body.
`SchPage` - has "search" as its slug, only one example in data without any real content in it. Will map to our specific search page?
`CendirPage` - has "resources" as its slug, only one example in data
`TumPage` - has slugs under the "projects" sections eg projects/criticism-now/criticism-in-the-digital-age, seems to represent reviews or critical feedback? Many examples in the data
`CenvidPage` - represents /videos, which we will replace with /recordings, most probably. Only one example in data
`CenmemPage` - represents /members, and shows a login form. which we will probably be replaced in the process of setting up either Discourse or Disqus? Only one example in data
`CmtPage` - represents /comments, and shows a list of comments. Likely to be replaced with Discourse/Disqus?

    Page # page
    CenevtPage # events_index
    FaqPage # page
    PslPage # page
    CttPage # page
    SchPage # N/A
    DirPage # page
    CendirPage # N/A
    TumPage # blog listing-ish thing
    DbyPage # page
    CenvidPage # recording
    CenmemPage # N/A
    CmtPage # N/A
    LnkPage # N/A Homepage
    CencalPage # N/A
    CenplaPage # page with collections underneath
    Asset
    CencalEvent
    CenevtPresentation
    CenevtPresenter
    CenevtProgram
    CenevtSponsor
    CenevtSponsorship
    CenevtVenue
    CenmemMemberInterest
    CenmemMemberInterestCategory
    CenplaBook
    CenvidJob
    CenvidNotification
    CenvidPost
    CenvidVideo
    CttRecipient
    DefaultSetting
    DirListing # merge all into DirPage body
    Draft
    EvtEvent
    CenevtEvent
    FaqQuestion # merge all into FaqPage
    Geocode
    LnkLink
    MemActivity
    MemCategory
    CenmemMember
    DbyPost
    Pathprint
    PslPerson
    Role
    Setting
    Tag
    TagPhrase
    Thumbnail
    TumWidget
    TumArticle
    TumQuote
    TumLink
    TumImage
    TumSound
    User