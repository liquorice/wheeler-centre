module LegacyBlueprint
  class Base < SimpleDelegator
    def initialize(*)
      __setobj__({})
    end

    def init_with(coder)
      __setobj__(coder['attributes'])
    end

    def yaml_initialize(tag, val)
      __setobj__(val["attributes"])
    end
  end

  %i(
    Page
    CenevtPage
    FaqPage
    PslPage
    CttPage
    SchPage
    DirPage
    CendirPage
    TumPage
    DbyPage
    CenvidPage
    CenmemPage
    CmtPage
    LnkPage
    CencalPage
    CenplaPage
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
    DirListing
    Draft
    EvtEvent
    CenevtEvent
    FaqQuestion
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
  ).each do |legacy_class|
    eval "class #{legacy_class} < Base; end"
  end
end
