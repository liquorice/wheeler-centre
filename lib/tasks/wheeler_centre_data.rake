# String helpers
def clean_content(str)
  str.strip.gsub(/\n\n/, "\n")
end

# Tag helpers
def blueprint_tag_to_topic_url_mappings
  [
    { slug: "", url: "topics"},

    { slug: "books", url: "topics/books-reading-and-writing"},
    { slug: "reading", url: "topics/books-reading-and-writing"},
    { slug: "writing", url: "topics/books-reading-and-writing"},
    { slug: "writers", url: "topics/books-reading-and-writing"},
    { slug: "authors", url: "topics/books-reading-and-writing"},

    { slug: "fiction", url: "topics/books-reading-and-writing/fiction"},
    { slug: "literature", url: "topics/books-reading-and-writing/fiction"},
    { slug: "short-stories", url: "topics/books-reading-and-writing/fiction"},

    { slug: "classics", url: "topics/books-reading-and-writing/fiction/classics"},
    { slug: "texts in the city", url: "topics/books-reading-and-writing/fiction/classics"},
    { slug: "shakespeare", url: "topics/books-reading-and-writing/fiction/classics"},

    { slug: "crime", url: "topics/books-reading-and-writing/fiction/crime-and-pulp"},
    { slug: "fiction", url: "topics/books-reading-and-writing/fiction/crime-and-pulp"},
    { slug: "pulp", url: "topics/books-reading-and-writing/fiction/crime-and-pulp"},

    { slug: "erotica", url: "topics/books-reading-and-writing/fiction/erotica"},
    { slug: "erotic-fan-fiction", url: "topics/books-reading-and-writing/fiction/erotica"},

    { slug: "creative-nonfiction", url: "topics/books-reading-and-writing/non-fiction"},
    { slug: "nonfiction", url: "topics/books-reading-and-writing/non-fiction"},
    { slug: "non-fiction", url: "topics/books-reading-and-writing/non-fiction"},
    { slug: "nonfictionow", url: "topics/books-reading-and-writing/non-fiction"},
    { slug: "journalism", url: "topics/books-reading-and-writing/non-fiction"},
    { slug: "essay", url: "topics/books-reading-and-writing/non-fiction"},
    { slug: "essays", url: "topics/books-reading-and-writing/non-fiction"},

    { slug: "autobiography", url: "topics/books-reading-and-writing/non-fiction/biography-and-memoir"},
    { slug: "memoir", url: "topics/books-reading-and-writing/non-fiction/biography-and-memoir"},
    { slug: "biography", url: "topics/books-reading-and-writing/non-fiction/biography-and-memoir"},
    { slug: "storytelling", url: "topics/books-reading-and-writing/non-fiction/biography-and-memoir"},
    { slug: "epic-fail", url: "topics/books-reading-and-writing/non-fiction/biography-and-memoir"},


    { slug: "true-crime", url: "topics/books-reading-and-writing/non-fiction/crime"},

    { slug: "childrens", url: "topics/books-reading-and-writing/children-s-books"},
    { slug: "childrens-book-festival", url: "topics/books-reading-and-writing/children-s-books"},
    { slug: "100-story-building", url: "topics/books-reading-and-writing/children-s-books"},

    { slug: "poems", url: "topics/books-reading-and-writing/poetry"},
    { slug: "poetry", url: "topics/books-reading-and-writing/poetry"},
    { slug: "australian-poetry", url: "topics/books-reading-and-writing/poetry"},
    { slug: "slam-poetry", url: "topics/books-reading-and-writing/poetry"},
    { slug: "spoken-word", url: "topics/books-reading-and-writing/poetry"},
    { slug: "oral-storytelling", url: "topics/books-reading-and-writing/poetry"},

    { slug: "graphic", url: "topics/books-reading-and-writing/graphic-novels-and-comics"},
    { slug: "comics", url: "topics/books-reading-and-writing/graphic-novels-and-comics"},
    { slug: "graphic novels", url: "topics/books-reading-and-writing/graphic-novels-and-comics"},
    { slug: "illustration", url: "topics/books-reading-and-writing/graphic-novels-and-comics"},

    { slug: "criticism", url: "topics/books-reading-and-writing/criticism"},
    { slug: "critical-failure", url: "topics/books-reading-and-writing/criticism"},
    { slug: "criticism-now", url: "topics/books-reading-and-writing/criticism"},
    { slug: "the-long-view", url: "topics/books-reading-and-writing/criticism"},

    { slug: "australian-literature", url: "topics/books-reading-and-writing/australian-stories"},
    { slug: "indigenous", url: "topics/books-reading-and-writing/australian-stories"},
    { slug: "australian-literature 101", url: "topics/books-reading-and-writing/australian-stories"},
    { slug: "australian-literature 102", url: "topics/books-reading-and-writing/australian-stories"},
    { slug: "australian-poetry", url: "topics/books-reading-and-writing/australian-stories"},
    { slug: "australian-writers", url: "topics/books-reading-and-writing/australian-stories"},
    { slug: "australian-love stories", url: "topics/books-reading-and-writing/australian-stories"},
    { slug: "express-media", url: "topics/books-reading-and-writing/australian-stories"},
    { slug: "country-sky water fire", url: "topics/books-reading-and-writing/australian-stories"},

    { slug: "publishing", url: "topics/books-reading-and-writing/editing-publishing-and-book-design"},
    { slug: "blogging", url: "topics/books-reading-and-writing/editing-publishing-and-book-design"},
    { slug: "book design", url: "topics/books-reading-and-writing/editing-publishing-and-book-design"},
    { slug: "editing", url: "topics/books-reading-and-writing/editing-publishing-and-book-design"},
    { slug: "editors", url: "topics/books-reading-and-writing/editing-publishing-and-book-design"},
    { slug: "publishing", url: "topics/books-reading-and-writing/editing-publishing-and-book-design"},
    { slug: "ebooks", url: "topics/books-reading-and-writing/editing-publishing-and-book-design"},

    { slug: "literary-journals", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "journals", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "magazines", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "meanland", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "overland", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "meanjin", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "voiceworks", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "express-media", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "mcsweeneys", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "lifted-brow", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "zines", url: "topics/books-reading-and-writing/journals-and-magazines"},
    { slug: "island", url: "topics/books-reading-and-writing/journals-and-magazines"},

    { slug: "emerging", url: "topics/books-reading-and-writing/new-and-emerging-writers"},
    { slug: "emerging-writers-festival", url: "topics/books-reading-and-writing/new-and-emerging-writers"},
    { slug: "digital-writers-festival", url: "topics/books-reading-and-writing/new-and-emerging-writers"},
    { slug: "the-next-big-thing", url: "topics/books-reading-and-writing/new-and-emerging-writers"},
    { slug: "debut-mondays", url: "topics/books-reading-and-writing/new-and-emerging-writers"},
    { slug: "now-read-this", url: "topics/books-reading-and-writing/new-and-emerging-writers"},

    { slug: "bookshops", url: "topics/books-reading-and-writing/bookshops"},
    { slug: "bookselling", url: "topics/books-reading-and-writing/bookshops"},
    { slug: "ebooks", url: "topics/books-reading-and-writing/bookshops"},

    { slug: "prizes", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "awards", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "victorian-premier-s-literary-awards", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "victorian-premiers-literary-awards", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "man-booker-prize", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "stella-prize", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "miles-franklin", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "vogel", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "walkleys", url: "topics/books-reading-and-writing/awards-and-prizes"},
    { slug: "literary-awards", url: "topics/books-reading-and-writing/awards-and-prizes"},

    { slug: "language", url: "topics/books-reading-and-writing/words-and-language"},
    { slug: "dictionary", url: "topics/books-reading-and-writing/words-and-language"},
    { slug: "linguistics", url: "topics/books-reading-and-writing/words-and-language"},
    { slug: "translation", url: "topics/books-reading-and-writing/words-and-language"},

    { slug: "funding", url: "topics/books-reading-and-writing/funding"},
    { slug: "fundraising", url: "topics/books-reading-and-writing/funding"},
    { slug: "philanthropy", url: "topics/books-reading-and-writing/funding"},

    { slug: "creativity", url: "topics/books-reading-and-writing/creativity"},
    { slug: "working-with-words", url: "topics/books-reading-and-writing/creativity"},


    { slug: "breakfast-club", url: "topics/visual-art-and-design"},
    { slug: "art-and-us", url: "topics/visual-art-and-design"},
    { slug: "street-art", url: "topics/visual-art-and-design"},
    { slug: "australian-art", url: "topics/visual-art-and-design"},

    { slug: "art-history", url: "topics/visual-art-and-design/art/art-history"},

    { slug: "urban", url: "topics/visual-art-and-design/urban-design"},
    { slug: "reading-the-city", url: "topics/visual-art-and-design/urban-design"},

    { slug: "graphic", url: "topics/visual-art-and-design/graphic-design"},
    { slug: "graphic-design", url: "topics/visual-art-and-design/graphic-design"},
    { slug: "book-design", url: "topics/visual-art-and-design/graphic-design"},
    { slug: "design", url: "topics/visual-art-and-design/graphic-design"},

    { slug: "funding", url: "topics/visual-art-and-design/funding"},
    { slug: "fundraising", url: "topics/visual-art-and-design/funding"},
    { slug: "philanthropy", url: "topics/visual-art-and-design/funding"},

    { slug: "pop-culture", url: "topics/performing-arts-and-pop-culture"},

    { slug: "culture", url: "topics/performing-arts-and-pop-culture"},
    { slug: "festival-of-live-art", url: "topics/performing-arts-and-pop-culture"},
    { slug: "celebrity", url: "topics/performing-arts-and-pop-culture"},
    { slug: "show-of-the-year", url: "topics/performing-arts-and-pop-culture"},
    { slug: "myth", url: "topics/performing-arts-and-pop-culture"},

    { slug: "music", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "jazz", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "jazzland", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "melbourne-international-jazz-festival", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "words-and-music", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "opera", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "the-ring-festival", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "disco", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "techno", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "rock-and-roll", url: "topics/performing-arts-and-pop-culture/music"},
    { slug: "songwriting", url: "topics/performing-arts-and-pop-culture/music"},

    { slug: "theatre", url: "topics/performing-arts-and-pop-culture/theatre"},
    { slug: "plays", url: "topics/performing-arts-and-pop-culture/theatre"},
    { slug: "drama", url: "topics/performing-arts-and-pop-culture/theatre"},

    { slug: "tv", url: "topics/performing-arts-and-pop-culture/tv"},
    { slug: "television", url: "topics/performing-arts-and-pop-culture/tv"},
    { slug: "australian-tv", url: "topics/performing-arts-and-pop-culture/tv"},

    { slug: "sport", url: "topics/performing-arts-and-pop-culture/sport"},
    { slug: "afl", url: "topics/performing-arts-and-pop-culture/sport"},
    { slug: "cricket", url: "topics/performing-arts-and-pop-culture/sport"},

    { slug: "gaming", url: "topics/performing-arts-and-pop-culture/games"},

    { slug: "eavesdropping-on-artists", url: "topics/performing-arts-and-pop-culture/creativity"},

    { slug: "television", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "tv", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "film", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "radio", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "advertising", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "newspapers", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "publishing", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "magazines", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "literary-journals", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "journals", url: "topics/performing-arts-and-pop-culture/media"},
    { slug: "new-news", url: "topics/performing-arts-and-pop-culture/media"},

    { slug: "society", url: "topics/history-politics-and-current-affairs"},
    { slug: "intelligence-squared-debates", url: "topics/history-politics-and-current-affairs"},

    { slug: "policy", url: "topics/history-politics-and-current-affairs/australian-politics"},
    { slug: "the-fifth-estate", url: "topics/history-politics-and-current-affairs/australian-politics"},

    { slug: "history", url: "topics/history-politics-and-current-affairs/history"},
    { slug: "australian-history", url: "topics/history-politics-and-current-affairs/history"},

    { slug: "war", url: "topics/history-politics-and-current-affairs/defence-military-and-war"},
    { slug: "military", url: "topics/history-politics-and-current-affairs/defence-military-and-war"},
    { slug: "army", url: "topics/history-politics-and-current-affairs/defence-military-and-war"},
    { slug: "navy", url: "topics/history-politics-and-current-affairs/defence-military-and-war"},
    { slug: "defence", url: "topics/history-politics-and-current-affairs/defence-military-and-war"},
    { slug: "terrorism", url: "topics/history-politics-and-current-affairs/defence-military-and-war"},

    { slug: "social-enterprise", url: "topics/history-politics-and-current-affairs/activism"},
    { slug: "boycott", url: "topics/history-politics-and-current-affairs/activism"},
    { slug: "gay-rights", url: "topics/history-politics-and-current-affairs/activism"},
    { slug: "animal-rights", url: "topics/history-politics-and-current-affairs/activism"},
    { slug: "human-rights", url: "topics/history-politics-and-current-affairs/activism"},
    { slug: "dissent", url: "topics/history-politics-and-current-affairs/activism"},
    { slug: "trade-unions", url: "topics/history-politics-and-current-affairs/activism"},

    { slug: "international-relations", url: "topics/history-politics-and-current-affairs/international-relations-and-diplomacy"},
    { slug: "foreign-affairs", url: "topics/history-politics-and-current-affairs/international-relations-and-diplomacy"},
    { slug: "diplomacy", url: "topics/history-politics-and-current-affairs/international-relations-and-diplomacy"},
    { slug: "globalisation", url: "topics/history-politics-and-current-affairs/international-relations-and-diplomacy"},
    { slug: "terrorism", url: "topics/history-politics-and-current-affairs/international-relations-and-diplomacy"},

    { slug: "australian-politics", url: "topics/history-politics-and-current-affairs/government"},
    { slug: "politics", url: "topics/history-politics-and-current-affairs/government"},
    { slug: "policy", url: "topics/history-politics-and-current-affairs/government"},

    { slug: "gender", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "sex", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "feminism", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "men", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "women", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "transgender", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "intersex", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "middlesex-queer-week", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "men-overboard", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "let-s-talk-about-sex", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "sexuality", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "sex-week", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "queer", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},
    { slug: "gay-rights", url: "topics/history-politics-and-current-affairs/sexual-and-gender-politics"},

    { slug: "speech", url: "topics/history-politics-and-current-affairs/speech-and-oration"},
    { slug: "oration", url: "topics/history-politics-and-current-affairs/speech-and-oration"},

    { slug: "society", url: "topics/free-speech-human-rights-and-social-issues"},

    { slug: "freedom-of-speech", url: "topics/free-speech-human-rights-and-social-issues/freedom-of-speech-and-censorship"},
    { slug: "censorship", url: "topics/free-speech-human-rights-and-social-issues/freedom-of-speech-and-censorship"},

    { slug: "social-justice", url: "topics/free-speech-human-rights-and-social-issues/social-justice"},
    { slug: "social-enterprise", url: "topics/free-speech-human-rights-and-social-issues/social-justice"},
    { slug: "culture", url: "topics/free-speech-human-rights-and-social-issues/social-justice"},
    { slug: "violence", url: "topics/free-speech-human-rights-and-social-issues/social-justice"},
    { slug: "addiction", url: "topics/free-speech-human-rights-and-social-issues/social-justice"},
    { slug: "poverty", url: "topics/free-speech-human-rights-and-social-issues/social-justice"},
    { slug: "wealth", url: "topics/free-speech-human-rights-and-social-issues/social-justice"},
    { slug: "development", url: "topics/free-speech-human-rights-and-social-issues/social-justice"},

    { slug: "human-rights", url: "topics/free-speech-human-rights-and-social-issues/human-rights"},
    { slug: "justice", url: "topics/free-speech-human-rights-and-social-issues/human-rights"},

    { slug: "security", url: "topics/free-speech-human-rights-and-social-issues/privacy"},
    { slug: "surveillance", url: "topics/free-speech-human-rights-and-social-issues/privacy"},
    { slug: "espionage", url: "topics/free-speech-human-rights-and-social-issues/privacy"},
    { slug: "encryption", url: "topics/free-speech-human-rights-and-social-issues/privacy"},
    { slug: "terrorism", url: "topics/free-speech-human-rights-and-social-issues/privacy"},

    { slug: "social-enterprise", url: "topics/free-speech-human-rights-and-social-issues/activism"},
    { slug: "boycott", url: "topics/free-speech-human-rights-and-social-issues/activism"},
    { slug: "dissent", url: "topics/free-speech-human-rights-and-social-issues/activism"},

    { slug: "race", url: "topics/race-religion-and-identity"},
    { slug: "racism", url: "topics/race-religion-and-identity"},
    { slug: "multiculturalism", url: "topics/race-religion-and-identity"},

    { slug: "a-question-of-identity", url: "topics/race-religion-and-identity/identity"},
    { slug: "anthropology", url: "topics/race-religion-and-identity/identity"},

    { slug: "theology", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "faith-and-culture", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "religion", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "christianity", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "islam", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "catholicism", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "hinduism", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "sikhism", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "judaism", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "spirituality", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "animism", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "muslim", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},
    { slug: "interfaith", url: "topics/race-religion-and-identity/faith-religion-and-spirituality"},

    { slug: "interfaith", url: "topics/race-religion-and-identity/diversity"},
    { slug: "queer", url: "topics/race-religion-and-identity/diversity"},
    { slug: "racism", url: "topics/race-religion-and-identity/diversity"},

    { slug: "young-adults", url: "topics/race-religion-and-identity/young-people"},
    { slug: "youth", url: "topics/race-religion-and-identity/young-people"},

    { slug: "immigration", url: "topics/race-religion-and-identity/migration"},
    { slug: "asylum-seekers", url: "topics/race-religion-and-identity/migration"},

    { slug: "new-south-wales", url: "topics/race-religion-and-identity/australia"},
    { slug: "victoria", url: "topics/race-religion-and-identity/australia"},
    { slug: "western-australia", url: "topics/race-religion-and-identity/australia"},
    { slug: "queensland", url: "topics/race-religion-and-identity/australia"},
    { slug: "brisbane", url: "topics/race-religion-and-identity/australia"},
    { slug: "melbourne", url: "topics/race-religion-and-identity/australia"},
    { slug: "sydney", url: "topics/race-religion-and-identity/australia"},
    { slug: "darwin", url: "topics/race-religion-and-identity/australia"},
    { slug: "northern-territory", url: "topics/race-religion-and-identity/australia"},
    { slug: "hobart", url: "topics/race-religion-and-identity/australia"},
    { slug: "geelong", url: "topics/race-religion-and-identity/australia"},
    { slug: "sale", url: "topics/race-religion-and-identity/australia"},
    { slug: "mildura", url: "topics/race-religion-and-identity/australia"},
    { slug: "frankston", url: "topics/race-religion-and-identity/australia"},
    { slug: "aireys-inlet", url: "topics/race-religion-and-identity/australia"},
    { slug: "ballarat", url: "topics/race-religion-and-identity/australia"},
    { slug: "bendigo", url: "topics/race-religion-and-identity/australia"},
    { slug: "south-australia", url: "topics/race-religion-and-identity/australia"},
    { slug: "adelaide", url: "topics/race-religion-and-identity/australia"},
    { slug: "perth", url: "topics/race-religion-and-identity/australia"},
    { slug: "australian-politics", url: "topics/race-religion-and-identity/australia"},
    { slug: "australian-tv", url: "topics/race-religion-and-identity/australia"},
    { slug: "australian-literature", url: "topics/race-religion-and-identity/australia"},
    { slug: "indigenous", url: "topics/race-religion-and-identity/australia"},
    { slug: "country-sky-water-fire", url: "topics/race-religion-and-identity/australia"},

    { slug: "africa", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "egypt", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "liberia", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "libya", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "arab-spring", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "arab", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "morocco", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "south-africa", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "zimbabwe", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "zambia", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "kenya", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "ethiopia", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "sudan", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "african-union", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "ethiopia", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "somalia", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "pakistan", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "iran", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "iraq", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "yemen", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "saudi-arabia", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "syria", url: "topics/race-religion-and-identity/africa-and-middle-east"},
    { slug: "turkey", url: "topics/race-religion-and-identity/africa-and-middle-east"},

    { slug: "china", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "japan", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "korea", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "south-korea", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "north-korea", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "philippines", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "thailand", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "singapore", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "malaysia", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "asia", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "indonesia", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "india", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "pakistan", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "tibet", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "taiwan", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "hong-kong", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "cambodia", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "vietnam", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "laos", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "myanmar", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "bangladesh", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "sri-lanka", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "pacific", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "pacific-islands", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "new-zealand", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "tonga", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "solomon-islands", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "vanuatu", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "fiji", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "new-caledonia", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "samoa", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "papua-new-guinea", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "timor", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "east-timor", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "micronesia", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "melanesia", url: "topics/race-religion-and-identity/asia-and-pacific"},
    { slug: "nauru", url: "topics/race-religion-and-identity/asia-and-pacific"},

    { slug: "france", url: "topics/race-religion-and-identity/europe"},
    { slug: "england", url: "topics/race-religion-and-identity/europe"},
    { slug: "scotland", url: "topics/race-religion-and-identity/europe"},
    { slug: "ireland", url: "topics/race-religion-and-identity/europe"},
    { slug: "germany", url: "topics/race-religion-and-identity/europe"},
    { slug: "italy", url: "topics/race-religion-and-identity/europe"},
    { slug: "european union", url: "topics/race-religion-and-identity/europe"},
    { slug: "portugal", url: "topics/race-religion-and-identity/europe"},
    { slug: "spain", url: "topics/race-religion-and-identity/europe"},
    { slug: "switzerland", url: "topics/race-religion-and-identity/europe"},
    { slug: "austria", url: "topics/race-religion-and-identity/europe"},
    { slug: "greece", url: "topics/race-religion-and-identity/europe"},
    { slug: "poland", url: "topics/race-religion-and-identity/europe"},
    { slug: "uk", url: "topics/race-religion-and-identity/europe"},
    { slug: "united kingdom", url: "topics/race-religion-and-identity/europe"},
    { slug: "russia", url: "topics/race-religion-and-identity/europe"},
    { slug: "paris", url: "topics/race-religion-and-identity/europe"},
    { slug: "london", url: "topics/race-religion-and-identity/europe"},
    { slug: "berlin", url: "topics/race-religion-and-identity/europe"},

    { slug: "south america", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "north america", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "america", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "canada", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "usa", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "united states of america", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "mexico", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "central america", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "new york", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "chicago", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "los angeles", url: "topics/race-religion-and-identity/the-americas"},
    { slug: "boston", url: "topics/race-religion-and-identity/the-americas"},

    { slug: "sex", url: "topics/sex-and-gender/sex-and-relationships"},
    { slug: "let-s-talk-about-sex", url: "topics/sex-and-gender/sex-and-relationships"},
    { slug: "erotica", url: "topics/sex-and-gender/sex-and-relationships"},
    { slug: "erotic-fan-fiction", url: "topics/sex-and-gender/sex-and-relationships"},
    { slug: "relationships", url: "topics/sex-and-gender/sex-and-relationships"},
    { slug: "dating", url: "topics/sex-and-gender/sex-and-relationships"},

    { slug: "queer", url: "topics/sex-and-gender/gender"},
    { slug: "intersex", url: "topics/sex-and-gender/gender"},
    { slug: "trans", url: "topics/sex-and-gender/gender"},
    { slug: "transgender", url: "topics/sex-and-gender/gender"},
    { slug: "men-overboard", url: "topics/sex-and-gender/gender"},
    { slug: "diversity", url: "topics/sex-and-gender/gender"},
    { slug: "masculinity", url: "topics/sex-and-gender/gender"},

    { slug: "gay", url: "topics/sex-and-gender/sexuality"},
    { slug: "lesbian", url: "topics/sex-and-gender/sexuality"},
    { slug: "middlesex queer week", url: "topics/sex-and-gender/sexuality"},
    { slug: "gay rights", url: "topics/sex-and-gender/sexuality"},

    { slug: "feminism", url: "topics/sex-and-gender/sexism-and-feminism"},
    { slug: "sexism", url: "topics/sex-and-gender/sexism-and-feminism"},

    { slug: "erotica", url: "topics/sex-and-gender/erotica"},
    { slug: "pornography", url: "topics/sex-and-gender/erotica"},
    { slug: "erotic-fan-fiction", url: "topics/sex-and-gender/erotica"},

    { slug: "internet", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "digital", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "apps", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "online", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "blogging", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "social-media", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "web", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "trolls", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "hacking", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "twitter", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "reddit", url: "topics/internet-journalism-media-and-publishing/digital-culture"},
    { slug: "facebook", url: "topics/internet-journalism-media-and-publishing/digital-culture"},

    { slug: "publishing", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "digital", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "online", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "blogging", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "web", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "crikey", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "fairfax", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "new news", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "ebooks", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "book design", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "design", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "editing", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},
    { slug: "editors", url: "topics/internet-journalism-media-and-publishing/publishing-and-editing"},

    { slug: "social-media", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "television", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "tv", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "film", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "radio", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "advertising", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "newspapers", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "publishing", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "magazines", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "literary-journals", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "journals", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "new-news", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "twitter", url: "topics/internet-journalism-media-and-publishing/media"},
    { slug: "facebook", url: "topics/internet-journalism-media-and-publishing/media"},

    { slug: "privacy", url: "topics/internet-journalism-media-and-publishing/privacy-and-security"},
    { slug: "security", url: "topics/internet-journalism-media-and-publishing/privacy-and-security"},
    { slug: "espionage", url: "topics/internet-journalism-media-and-publishing/privacy-and-security"},
    { slug: "surveillance", url: "topics/internet-journalism-media-and-publishing/privacy-and-security"},
    { slug: "encryption", url: "topics/internet-journalism-media-and-publishing/privacy-and-security"},
    { slug: "wikileaks", url: "topics/internet-journalism-media-and-publishing/privacy-and-security"},
    { slug: "terrorism", url: "topics/internet-journalism-media-and-publishing/privacy-and-security"},

    { slug: "leaks", url: "topics/internet-journalism-media-and-publishing/leaking-and-whistleblowing"},
    { slug: "leaking", url: "topics/internet-journalism-media-and-publishing/leaking-and-whistleblowing"},
    { slug: "whistleblowers", url: "topics/internet-journalism-media-and-publishing/leaking-and-whistleblowing"},
    { slug: "whistleblowing", url: "topics/internet-journalism-media-and-publishing/leaking-and-whistleblowing"},
    { slug: "wikileaks", url: "topics/internet-journalism-media-and-publishing/leaking-and-whistleblowing"},

    { slug: "money", url: "topics/economics-business-and-marketing"},
    { slug: "economics", url: "topics/economics-business-and-marketing"},

    { slug: "economy", url: "topics/economics-business-and-marketing/economy-and-development"},
    { slug: "development", url: "topics/economics-business-and-marketing/economy-and-development"},

    { slug: "reading-on-vocation", url: "topics/economics-business-and-marketing/work"},
    { slug: "jobs", url: "topics/economics-business-and-marketing/work"},

    { slug: "marketing", url: "topics/economics-business-and-marketing/marketing-and-publicity"},
    { slug: "publicity", url: "topics/economics-business-and-marketing/marketing-and-publicity"},

    { slug: "business", url: "topics/economics-business-and-marketing/business-and-finance"},
    { slug: "finance", url: "topics/economics-business-and-marketing/business-and-finance"},
    { slug: "social-enterprise", url: "topics/economics-business-and-marketing/business-and-finance"},
    { slug: "retail", url: "topics/economics-business-and-marketing/business-and-finance"},

    { slug: "funding", url: "topics/economics-business-and-marketing/funding-and-philanthropy"},
    { slug: "fundraising", url: "topics/economics-business-and-marketing/funding-and-philanthropy"},
    { slug: "philanthropy", url: "topics/economics-business-and-marketing/funding-and-philanthropy"},

    { slug: "teaching", url: "topics/education-literacy-and-numeracy"},
    { slug: "university", url: "topics/education-literacy-and-numeracy"},
    { slug: "academic", url: "topics/education-literacy-and-numeracy"},
    { slug: "academia", url: "topics/education-literacy-and-numeracy"},

    { slug: "reading", url: "topics/education-literacy-and-numeracy/literacy"},

    { slug: "maths", url: "topics/education-literacy-and-numeracy/mathematics"},
    { slug: "numeracy", url: "topics/education-literacy-and-numeracy/mathematics"},
    { slug: "numbers", url: "topics/education-literacy-and-numeracy/mathematics"},

    { slug: "deakins", url: "topics/energy-environment-and-climate"},

    { slug: "country sky", url: "topics/energy-environment-and-climate/environment"},
    { slug: "water", url: "topics/energy-environment-and-climate/environment"},
    { slug: "fire", url: "topics/energy-environment-and-climate/environment"},
    { slug: "nature", url: "topics/energy-environment-and-climate/environment"},
    { slug: "sustainability", url: "topics/energy-environment-and-climate/environment"},
    { slug: "rubbish", url: "topics/energy-environment-and-climate/environment"},

    { slug: "climate-change", url: "topics/energy-environment-and-climate/climate-change-and-weather"},
    { slug: "weather", url: "topics/energy-environment-and-climate/climate-change-and-weather"},
    { slug: "weather-stations", url: "topics/energy-environment-and-climate/climate-change-and-weather"},
    { slug: "pollution", url: "topics/energy-environment-and-climate/climate-change-and-weather"},
    { slug: "sustainability", url: "topics/energy-environment-and-climate/climate-change-and-weather"},

    { slug: "energy", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "pollution", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "coal", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "solar", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "gas", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "nuclear", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "climate-change", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "transport", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "mining", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "bicycle", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "bike", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "public-transport", url: "topics/energy-environment-and-climate/energy-and-resources"},
    { slug: "sustainability", url: "topics/energy-environment-and-climate/energy-and-resources"},

    { slug: "food", url: "topics/energy-environment-and-climate/food"},
    { slug: "eating", url: "topics/energy-environment-and-climate/food"},
    { slug: "cooking", url: "topics/energy-environment-and-climate/food"},
    { slug: "water-security", url: "topics/energy-environment-and-climate/food"},
    { slug: "water", url: "topics/energy-environment-and-climate/food"},
    { slug: "on-water", url: "topics/energy-environment-and-climate/food"},

    { slug: "animals", url: "topics/energy-environment-and-climate/animals-and-nature"},
    { slug: "nature", url: "topics/energy-environment-and-climate/animals-and-nature"},
    { slug: "melbourne zoo", url: "topics/energy-environment-and-climate/animals-and-nature"},
    { slug: "animal rights", url: "topics/energy-environment-and-climate/animals-and-nature"},
    { slug: "cats", url: "topics/energy-environment-and-climate/animals-and-nature"},
    { slug: "dogs", url: "topics/energy-environment-and-climate/animals-and-nature"},

    { slug: "urban", url: "topics/energy-environment-and-climate/cities"},
    { slug: "ideas for melbourne", url: "topics/energy-environment-and-climate/cities"},
    { slug: "architecture in the city", url: "topics/energy-environment-and-climate/cities"},
    { slug: "reading the city", url: "topics/energy-environment-and-climate/cities"},
    { slug: "population", url: "topics/energy-environment-and-climate/cities"},
    { slug: "transport", url: "topics/energy-environment-and-climate/cities"},

    { slug: "rural", url: "topics/energy-environment-and-climate/country-and-rural"},
    { slug: "transport", url: "topics/energy-environment-and-climate/country-and-rural"},
    { slug: "agriculture", url: "topics/energy-environment-and-climate/country-and-rural"},

    { slug: "body", url: "topics/health-medicine-and-psychology"},

    { slug: "life", url: "topics/health-medicine-and-psychology/life-and-death"},
    { slug: "death", url: "topics/health-medicine-and-psychology/life-and-death"},
    { slug: "obits", url: "topics/health-medicine-and-psychology/life-and-death"},
    { slug: "matter-of-life-and-death", url: "topics/health-medicine-and-psychology/life-and-death"},
    { slug: "births-deaths-and-marriages", url: "topics/health-medicine-and-psychology/life-and-death"},
    { slug: "marriage", url: "topics/health-medicine-and-psychology/life-and-death"},
    { slug: "birth", url: "topics/health-medicine-and-psychology/life-and-death"},
    { slug: "school-of-life", url: "topics/health-medicine-and-psychology/life-and-death"},
    { slug: "parenting", url: "topics/health-medicine-and-psychology/life-and-death"},

    { slug: "health", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "medicine", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "medical", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "surgery", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "disease", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "cancer", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "hiv", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "aids", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "hiv-aids", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "neuroscience", url: "topics/health-medicine-and-psychology/health-and-medicine"},
    { slug: "doctors", url: "topics/health-medicine-and-psychology/health-and-medicine"},

    { slug: "deaf", url: "topics/health-medicine-and-psychology/deaf"},
    { slug: "auslan", url: "topics/health-medicine-and-psychology/deaf"},

    { slug: "psychology", url: "topics/health-medicine-and-psychology/psychology-and-mental-health"},
    { slug: "mental health", url: "topics/health-medicine-and-psychology/psychology-and-mental-health"},
    { slug: "psychopaths", url: "topics/health-medicine-and-psychology/psychology-and-mental-health"},
    { slug: "anxiety", url: "topics/health-medicine-and-psychology/psychology-and-mental-health"},
    { slug: "depression", url: "topics/health-medicine-and-psychology/psychology-and-mental-health"},
    { slug: "shy", url: "topics/health-medicine-and-psychology/psychology-and-mental-health"},
    { slug: "neuroscience", url: "topics/health-medicine-and-psychology/psychology-and-mental-health"},

    { slug: "food", url: "topics/health-medicine-and-psychology/food-and-nutrition"},
    { slug: "nutrition", url: "topics/health-medicine-and-psychology/food-and-nutrition"},
    { slug: "diet", url: "topics/health-medicine-and-psychology/food-and-nutrition"},
    { slug: "eating", url: "topics/health-medicine-and-psychology/food-and-nutrition"},

    { slug: "youth", url: "topics/health-medicine-and-psychology/young-and-old"},
    { slug: "young-adults", url: "topics/health-medicine-and-psychology/young-and-old"},
    { slug: "ageing", url: "topics/health-medicine-and-psychology/young-and-old"},

    { slug: "sport", url: "topics/health-medicine-and-psychology/sport"},
    { slug: "sports", url: "topics/health-medicine-and-psychology/sport"},

    { slug: "science", url: "topics/science-and-technology"},
    { slug: "neuroscience", url: "topics/science-and-technology"},

    { slug: "technology", url: "topics/science-and-technology/technology"},
    { slug: "computers", url: "topics/science-and-technology/technology"},
    { slug: "computing", url: "topics/science-and-technology/technology"},
    { slug: "data", url: "topics/science-and-technology/technology"},
    { slug: "internet", url: "topics/science-and-technology/technology"},
    { slug: "digital", url: "topics/science-and-technology/technology"},
    { slug: "apps", url: "topics/science-and-technology/technology"},
    { slug: "artificial intelligence", url: "topics/science-and-technology/technology"},
    { slug: "robots", url: "topics/science-and-technology/technology"},
    { slug: "manufacturing", url: "topics/science-and-technology/technology"},
    { slug: "nanotechnology", url: "topics/science-and-technology/technology"},
    { slug: "phones", url: "topics/science-and-technology/technology"},
    { slug: "electronics", url: "topics/science-and-technology/technology"},
    { slug: "engineering", url: "topics/science-and-technology/technology"},

    { slug: "astronomy", url: "topics/science-and-technology/space"},
    { slug: "space", url: "topics/science-and-technology/space"},

    { slug: "law", url: "topics/law-ethics-and-philosophy"},
    { slug: "legal", url: "topics/law-ethics-and-philosophy"},
    { slug: "justice", url: "topics/law-ethics-and-philosophy"},
    { slug: "law-and-order-week", url: "topics/law-ethics-and-philosophy"},

    { slug: "crime", url: "topics/law-ethics-and-philosophy/crime"},
    { slug: "true-crime", url: "topics/law-ethics-and-philosophy/crime"},
    { slug: "prison", url: "topics/law-ethics-and-philosophy/crime"},

    { slug: "ethics", url: "topics/law-ethics-and-philosophy/ethics-and-morals"},
    { slug: "ethically-speaking", url: "topics/law-ethics-and-philosophy/ethics-and-morals"},
    { slug: "morality", url: "topics/law-ethics-and-philosophy/ethics-and-morals"},

    { slug: "privacy", url: "topics/law-ethics-and-philosophy/privacy-and-security"},
    { slug: "security", url: "topics/law-ethics-and-philosophy/privacy-and-security"},
    { slug: "espionage", url: "topics/law-ethics-and-philosophy/privacy-and-security"},
    { slug: "surveillance", url: "topics/law-ethics-and-philosophy/privacy-and-security"},
    { slug: "encryption", url: "topics/law-ethics-and-philosophy/privacy-and-security"},
    { slug: "wikileaks", url: "topics/law-ethics-and-philosophy/privacy-and-security"},
  ]
end

def topics_mappings_by_slug(blueprint_slug)
  blueprint_tag_to_topic_url_mappings.select {|mapping| mapping[:slug] == blueprint_slug }
end

def find_topic_pages_by_slug(slug)
  Heracles::Page.of_type("topic").find_by_slug(slug)
end

def find_topic_page_by_url(url)
  Heracles::Page.of_type("topic").find_by_url(url)
end

def blueprint_tags(blueprint_records)
  blueprint_records.select { |r| r.class == LegacyBlueprint::Tag }
end

def blueprint_tags_for(tags, taggable_id, legacy_class)
  tags.select do |tag|
    tag["taggable_id"] == taggable_id && tag["taggable_type"] == legacy_class
  end
end

def replace_entities(title)
  title = title.gsub(/&lsquo;/, '‘')
  title = title.gsub(/&rsquo;/, '’')
  title
end

def apply_tags_to(page, blueprint_tags)

  topic_matches = []
  unmatched_tags = []
  blueprint_tags.each do |blueprint_tag|
    slug = blueprint_tag["slug"]
    mappings = topics_mappings_by_slug(slug)
    if mappings
      mappings.each do |mapping|
        match = find_topic_page_by_url(mapping[:url])
        topic_matches << match if match
      end
    else
      topics_by_slug = find_topic_pages_by_slug(slug)
      if topics_by_slug
        topics_by_slug.each do |topic|
          topic_matches << topic if topic
        end
      end
    end

    unless topic_matches.any?
      unmatched_tags << blueprint_tag
    end
  end
  puts topic_matches.inspect
  if topic_matches.any?
    page.fields[:topics].page_ids = topic_matches.map(&:id)
  end
  page.tag_list.add(unmatched_tags.map{|t| t["slug"] })
end

def blueprint_assets(blueprint_records)
  blueprint_records.select { |r| r.class == LegacyBlueprint::Asset }
end

namespace :wheeler_centre do
  task :yiew, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    tags = blueprint_tags(blueprint_records)
    tag_for = blueprint_tags_for(tags, "255", "CenvidPost")
    topic_matches = []
    unmatched_tags = []
    tag_for.each do |tag|
      topic = find_topic_page_by_slug(tag["slug"])
      if topic
        topic_matches << topic
      else
        unmatched_tags << tag
      end
    end
  end



  desc "Import Blueprint People"
  task :import_blueprint_people, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_asset_records = blueprint_assets(blueprint_records)

    blueprint_presenters = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtPresenter }
    blueprint_users = blueprint_records.select { |r| r.class == LegacyBlueprint::User }
    blueprint_staff = blueprint_records.select { |r| r.class == LegacyBlueprint::PslPerson }

    blueprint_presenters.each do |blueprint_presenter|
      heracles_person = Heracles::Sites::WheelerCentre::Person.find_by_slug(blueprint_presenter["slug"])
      unless heracles_person then heracles_person = Heracles::Page.new_for_site_and_page_type(site, "person") end
      heracles_person.published = true
      heracles_person.slug = blueprint_presenter["slug"]
      heracles_person.title = blueprint_presenter["name"]
      heracles_person.fields[:intro].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_presenter["intro"], subject: blueprint_presenter, assetify: false)
      heracles_person.fields[:biography].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_presenter["bio"], subject: blueprint_presenter, assetify: false)
      heracles_person.fields[:url].value = blueprint_presenter["url"]
      heracles_person.fields[:external_links].value = blueprint_presenter["external_links"]

      # Image
      blueprint_portrait_image = blueprint_asset_records.find {|r| (r["attachable_type"] == "CenevtPresenter" || r["assoc"] == "portrait") && r["id"].to_i == blueprint_presenter["portrait_id"].to_i}
      if blueprint_portrait_image.present?
        heracles_promo_image = Heracles::Asset.find_by_blueprint_id(blueprint_portrait_image["id"].to_i)
        if heracles_promo_image
          heracles_person.fields[:portrait].asset_id = heracles_promo_image.id
        else
          puts "*** Missing promo image for: #{blueprint_presenter["name"]}"
        end
      else
        puts "*** Missing promo image for: #{blueprint_presenter["name"]}"
      end

      # {name: :reviews, type: :content},
      # Find a staff member that matches this presenter
      staff_member = find_matching_staff_member(blueprint_presenter, blueprint_staff)
      if staff_member.present?
        puts (staff_member["slug"])
        heracles_person.fields[:is_staff_member].value = true
        heracles_person.fields[:staff_bio].value = LegacyBlueprint::BluedownFormatter.mark_up(staff_member["bio"], subject: staff_member, assetify: false)
        heracles_person.fields[:position_title].value = staff_member["title"]
        heracles_person.fields[:first_name].value = staff_member["first_name"]
        heracles_person.fields[:last_name].value = staff_member["surname"]
      else
        # We still need to split the name and assign to first_name and last_name
        names = blueprint_presenter["name"].split(" ")
        # Simply make the first component of the name the first_name
        heracles_person.fields[:first_name].value = names.first
        # Make everything else the last_name
        heracles_person.fields[:last_name].value = names.drop(1).join(" ")
      end
      # Find a matching user and set the id
      user = find_matching_user(blueprint_presenter, blueprint_users)
      if user.present?
        puts (user["id"])
        heracles_person.fields[:legacy_user_id].value = user["id"]
      end
      heracles_person.fields[:legacy_presenter_id].value = blueprint_presenter["id"]
      heracles_person.created_at = Time.zone.parse(blueprint_presenter["created_on"].to_s)
      heracles_person.parent = Heracles::Page.find_by_slug("people")
      heracles_person.collection = Heracles::Page.where(url: "people/all-people").first!
      puts (heracles_person.slug)
      heracles_person.save!
    end

    blueprint_users.each do |blueprint_user|
      if blueprint_user["name"].present?
        # Make a best effort to construct the slug, as we only have `name` to go by
        slug = blueprint_user["name"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        names = blueprint_user["name"].split(" ")
        existing_heracles_person = Heracles::Sites::WheelerCentre::Person.find_by_slug(slug)
        unless existing_heracles_person
          # Only create a new person if that slug doesn't already exist
          heracles_person = Heracles::Page.new_for_site_and_page_type(site, "person")
          heracles_person.published = true
          heracles_person.slug = slug
          unless blueprint_user["name"] then heracles_person.title = blueprint_user["name"] else heracles_person.title = slug end
          heracles_person.fields[:first_name].value = names.first
          heracles_person.fields[:last_name].value = names.drop(1).join(" ")
          heracles_person.fields[:legacy_user_id].value = blueprint_user["id"]
          heracles_person.created_at = Time.zone.parse(blueprint_user["created_on"].to_s)
          heracles_person.parent = Heracles::Page.find_by_slug("people")
          heracles_person.collection = Heracles::Page.where(url: "people/all-people").first!
          heracles_person.save!
        end
      end
    end

    blueprint_staff.each do |blueprint_staff_member|
      existing_heracles_person = Heracles::Sites::WheelerCentre::Person.find_by_slug(blueprint_staff_member["slug"])
      unless existing_heracles_person
        heracles_person = Heracles::Page.new_for_site_and_page_type(site, "person")
        heracles_person.published = true
        heracles_person.slug = blueprint_staff_member["slug"]
        heracles_person.title = blueprint_staff_member["first_name"] + " " + blueprint_staff_member["surname"]
        heracles_person.fields[:is_staff_member].value = true
        heracles_person.fields[:staff_bio].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_staff_member["bio"], subject: blueprint_staff_member, assetify: false)
        heracles_person.fields[:position_title].value = blueprint_staff_member["title"]
        heracles_person.fields[:first_name].value = blueprint_staff_member["first_name"]
        heracles_person.fields[:last_name].value = blueprint_staff_member["surname"]
        heracles_person.created_at = Time.zone.parse(blueprint_staff_member["created_on"].to_s)
        heracles_person.parent = Heracles::Page.find_by_slug("people")
        heracles_person.collection = Heracles::Page.where(url: "people/all-people").first!
        heracles_person.save!
      end
    end

  end


  desc "Import blueprint sponsors"
  task :import_blueprint_sponsors, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_asset_records = blueprint_assets(blueprint_records)

    blueprint_sponsors = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtSponsor }
    heracles_sponsors_index = Heracles::Page.where(slug: "sponsors").first!
    heracles_sponsors_collection = heracles_sponsors_index.children.of_type("collection").where(slug: "all-sponsors").first!

    blueprint_sponsors.each do |blueprint_sponsor|
      if blueprint_sponsor["title"].present?
        heracles_sponsor = Heracles::Sites::WheelerCentre::Sponsor.find_by_slug(blueprint_sponsor["slug"])
        unless heracles_sponsor
          heracles_sponsor = Heracles::Page.new_for_site_and_page_type(heracles_sponsors_index.site, "sponsor")
        end
        heracles_sponsor.slug = blueprint_sponsor["slug"]
        heracles_sponsor.title = blueprint_sponsor["title"]
        heracles_sponsor.created_at = Time.zone.parse(Time.now.to_s)
        heracles_sponsor.site = heracles_sponsors_index.site
        heracles_sponsor.parent = heracles_sponsors_index
        heracles_sponsor.collection = heracles_sponsors_collection
        heracles_sponsor.published = true

        blueprint_logo_image = blueprint_asset_records.find {|r| r["id"].to_i == blueprint_sponsor["logo_id"].to_i}
        if blueprint_logo_image.present?
          heracles_logo_image = Heracles::Asset.find_by_blueprint_id(blueprint_logo_image["id"].to_i)
          if heracles_logo_image
            heracles_sponsor.fields[:logo].asset_id = heracles_logo_image.id
          else
            puts "*** Missing logo image for: #{blueprint_sponsor["name"]}"
          end
        else
          puts "*** Missing logo image for: #{blueprint_sponsor["name"]}"
        end

        heracles_sponsor.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_sponsor["content"], subject: blueprint_sponsor, assetify: false)
        if blueprint_sponsor["url"].present? then heracles_sponsor.fields[:url].value = blueprint_sponsor["url"].to_s end
        if blueprint_sponsor["id"].present? then heracles_sponsor.fields[:sponsor_id].value = blueprint_sponsor["id"].to_i end
        # {name: :logo, type: :asset, asset_file_type: :image}
        heracles_sponsor.save!
      end
    end

  end

  desc "Import blueprint event venues"
  task :import_blueprint_event_venues, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_asset_records = blueprint_assets(blueprint_records)

    blueprint_venues = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtVenue }
    heracles_venues_index = Heracles::Page.where(slug: "venues").first!
    heracles_venues_collection = heracles_venues_index.children.of_type("collection").where(slug: "all-event-venues").first!

    blueprint_venues.each do |blueprint_venue|
      if blueprint_venue["name"].present?
        heracles_venue = Heracles::Sites::WheelerCentre::Venue.find_by_slug(blueprint_venue["slug"])
        unless heracles_venue
          heracles_venue = Heracles::Page.new_for_site_and_page_type(heracles_venues_index.site, "venue")
        end
        heracles_venue.slug = blueprint_venue["slug"]
        heracles_venue.title = blueprint_venue["name"]
        heracles_venue.created_at = Time.zone.parse(Time.now.to_s)
        heracles_venue.site = heracles_venues_index.site
        heracles_venue.parent = heracles_venues_index
        heracles_venue.collection = heracles_venues_collection
        heracles_venue.published = true

        heracles_venue.fields[:legacy_venue_id].value = blueprint_venue["id"]

        # Image
        blueprint_hero_image = blueprint_asset_records.find {|r| r["id"].to_i == blueprint_venue["main_photo_id"].to_i}
        if blueprint_hero_image.present?
          heracles_hero_image = Heracles::Asset.find_by_blueprint_id(blueprint_hero_image["id"].to_i)
          if heracles_hero_image
            heracles_venue.fields[:hero_image].asset_id = heracles_hero_image.id
          else
            puts "*** Missing hero image for: #{blueprint_venue["name"]}"
          end
        else
          puts "*** Missing hero image for: #{blueprint_venue["name"]}"
        end
        heracles_venue.fields[:address].value = blueprint_venue["address"]
        heracles_venue.fields[:address_formatted].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_venue["address"], subject: blueprint_venue, assetify: false)
        heracles_venue.fields[:phone_number].value = blueprint_venue["phone_number"]
        heracles_venue.fields[:description].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_venue["description"], subject: blueprint_venue, assetify: false)
        heracles_venue.fields[:directions].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_venue["directions"], subject: blueprint_venue, assetify: false)
        heracles_venue.fields[:parking].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_venue["parking"], subject: blueprint_venue, assetify: false)

        heracles_venue.save!
      end
    end

  end

  desc "Import blueprint event series"
  task :import_blueprint_event_series, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_asset_records = blueprint_assets(blueprint_records)

    blueprint_event_series = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtProgram }
    heracles_events_series_index = Heracles::Page.where(url: "events/series").first!
    heracles_events_series_collection = heracles_events_series_index.descendants.of_type("collection").where(slug: "all-event-series").first!

    blueprint_event_series.each do |blueprint_series|

      if blueprint_series["name"].present?
        heracles_series = Heracles::Sites::WheelerCentre::EventSeries.find_by_slug(blueprint_series["slug"])
        unless heracles_series
          heracles_series = Heracles::Page.new_for_site_and_page_type(heracles_events_series_index.site, "event_series")
          heracles_series.parent = heracles_events_series_index
          heracles_series.collection = heracles_events_series_collection
        end

        # Image
        blueprint_hero_image = blueprint_asset_records.find {|r| r["id"].to_i == blueprint_series["banner_id"].to_i}
        puts blueprint_hero_image.inspect
        if blueprint_hero_image.present?
          heracles_hero_image = Heracles::Asset.find_by_blueprint_id(blueprint_hero_image["id"].to_i)
          if heracles_hero_image
            heracles_series.fields[:hero_image].asset_id = heracles_hero_image.id
          else
            puts "*** Missing hero image for: #{blueprint_series["name"]}"
          end
        else
          puts "*** Missing hero image for: #{blueprint_series["name"]}"
        end

        heracles_series.published = true
        heracles_series.title = blueprint_series["name"]
        heracles_series.slug = blueprint_series["slug"]
        puts (blueprint_series["slug"])
        heracles_series.created_at = Time.zone.parse(blueprint_series["created_on"].to_s)
        if blueprint_series["content"].present? then heracles_series.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_series["content"], subject: blueprint_series, assetify: true) end
        if blueprint_series["id"].present?
          puts (blueprint_series["id"])
          heracles_series.fields[:legacy_series_id].value = blueprint_series["id"].to_i
        end
        heracles_series.fields[:archived].value = true

        heracles_series.save!
      end
    end

  end

  desc "Import blueprint events"
  task :import_blueprint_events, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_tag_records = blueprint_tags(blueprint_records)
    blueprint_asset_records = blueprint_assets(blueprint_records)

    blueprint_events = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtEvent}
    blueprint_sponsorships = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtSponsorship }
    blueprint_presentations = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtPresentation }
    heracles_events_index = Heracles::Page.where(url: "events").first!
    heracles_events_collection = heracles_events_index.children.of_type("collection").where(slug: "all-events").first!

    all_series = Heracles::Page.of_type("event_series")
    all_venues = Heracles::Page.of_type("venue")
    all_sponsors = Heracles::Page.of_type("sponsor")
    all_authors = Heracles::Page.of_type("person")

    blueprint_events.each do |blueprint_event|
      # Find an existing event
      heracles_event = heracles_events_index.children.of_type("event").find_by_slug(blueprint_event["slug"])

      # Or build a new one
      unless heracles_event
        heracles_event = Heracles::Page.new_for_site_and_page_type(heracles_events_index.site, "event")
        heracles_event.parent = heracles_events_index
        heracles_event.collection = heracles_events_collection
        heracles_event.slug = blueprint_event["slug"]
      end

      # Image
      blueprint_promo_image = blueprint_asset_records.find {|r| r["attachable_type"] == "EvtEvent" && r["attachable_id"].to_i == blueprint_event["id"].to_i && r["name"].to_s.downcase == "promo"}
      if blueprint_promo_image.present?
        heracles_promo_image = Heracles::Asset.find_by_blueprint_id(blueprint_promo_image["id"].to_i)
        if heracles_promo_image
          heracles_event.fields[:promo_image].asset_id = heracles_promo_image.id
        else
          puts "*** Missing promo image for: #{blueprint_event["title"]}"
        end
      else
        puts "*** Missing promo image for: #{blueprint_event["title"]}"
      end

      heracles_event.published = true
      heracles_event.title = replace_entities(blueprint_event["title"])
      puts (blueprint_event["slug"])
      heracles_event.created_at = Time.zone.parse(blueprint_event["created_on"].to_s)
      heracles_event.fields[:short_title].value = blueprint_event["short_title"].to_s
      heracles_event.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_event["content"], subject: blueprint_event, assetify: true)
      heracles_event.fields[:start_date].value = Time.zone.parse(blueprint_event["start_date"].to_s)
      heracles_event.fields[:end_date].value = Time.zone.parse(blueprint_event["end_date"].to_s)
      heracles_event.fields[:external_bookings].value = blueprint_event["booking_service_url"].to_s
      heracles_event.fields[:bookings_open_at].value = Time.zone.parse(blueprint_event["public_bookings_open_at"].to_s)

      # Associate event series with event
      event_series = all_series.select { |p| p.fields[:legacy_series_id].value.to_i == blueprint_event["program_id"].to_i }
      if event_series.present?
        heracles_event.fields[:series].page_ids = event_series.map(&:id)
      end

      # Associate venue with event
      event_venues = all_venues.select { |p| p.fields[:legacy_venue_id].value.to_i == blueprint_event["venue_id"].to_i }
      if event_venues.present?
        heracles_event.fields[:venue].page_ids = event_venues.map(&:id)
      end

      # Associate people with events through presentations
      presentations = blueprint_presentations.select { |blueprint_presentation| blueprint_event["id"].to_i == blueprint_presentation["event_id"].to_i }
      puts "#### #{presentations.length}"
      presenter_ids = presentations.map {|blueprint_presentation| blueprint_presentation["presenter_id"].to_i }
      puts "**** #{presenter_ids.join(", ")}"
      authors = all_authors.select { |p| presenter_ids.include?(p.fields[:legacy_presenter_id].value.to_i) }
      if authors.present?
        heracles_event.fields[:presenters].page_ids = authors.map(&:id)
      end

      # Find all the sponsors for this event and add them to the sponsors field on this event
      # This mirrors the data as it was in Blueprint, where the relationship was between events and sponsors
      event_sponsorships = find_matching_event_sponsorships(blueprint_event, blueprint_sponsorships)
      if event_sponsorships.present?
        sponsor_ids = event_sponsorships.map { |p| p["sponsor_id"].to_i }
        puts (sponsor_ids)
        sponsors = all_sponsors.select { |p| sponsor_ids.include?(p.fields[:sponsor_id].value.to_i) }
        if sponsors.present? then heracles_event.fields[:sponsors].page_ids = sponsors.map(&:id) end
      end

      tags_for_post = blueprint_tags_for(blueprint_tag_records, blueprint_event["id"], "EvtEvent")
      if tags_for_post.present?
        apply_tags_to(heracles_event, tags_for_post)
      end

      heracles_event.save!
    end
  end


  desc "Import Blueprint Dailies"
  task :import_blueprint_dailies, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_tag_records = blueprint_tags(blueprint_records)
    blueprint_asset_records = blueprint_assets(blueprint_records)

    dailies_root = blueprint_records.select { |r| r.class == LegacyBlueprint::TumPage && r["slug"] == "dailies" }
    id = dailies_root.first["id"].to_i

    blueprint_dailies_articles = blueprint_records.select { |r| r.class == LegacyBlueprint::TumArticle && r["page_id"].to_i == id }
    # blueprint_dailies_images   = blueprint_records.select { |r| r.class == LegacyBlueprint::TumImage && r["page_id"].to_i == id }

    all_authors = Heracles::Page.of_type("person")
    parent = Heracles::Page.find_by_slug("writings")
    collection = Heracles::Page.where(url: "writings/all-writings").first!

    blueprint_dailies_articles.each do |blueprint_daily|
      if blueprint_daily["title"].present?
        heracles_blog_post = Heracles::Page.find_by_slug(blueprint_daily["slug"])
        unless heracles_blog_post then heracles_blog_post = Heracles::Page.new_for_site_and_page_type(site, "blog_post") end
        heracles_blog_post.published = blueprint_daily["publish_on"].present?
        heracles_blog_post.slug = blueprint_daily["slug"]
        heracles_blog_post.title = replace_entities(blueprint_daily["title"])

        # Image
        blueprint_hero_image = blueprint_asset_records.find {|r| r["attachable_type"] == "TumPost" && r["attachable_id"].to_i == blueprint_daily["id"].to_i && r["name"].to_s.downcase == "highlight"}
        if blueprint_hero_image.present?
          heracles_hero_image = Heracles::Asset.find_by_blueprint_id(blueprint_hero_image["id"].to_i)
          if heracles_hero_image
            puts "*** Found hero image for: #{heracles_blog_post["title"]}"
            heracles_blog_post.fields[:hero_image].asset_id = heracles_hero_image.id
          else
            puts "*** Missing hero image for: #{heracles_blog_post["title"]}"
          end
        else
          puts "*** Missing hero image for: #{heracles_blog_post["title"]}"
        end

        content = blueprint_daily["content"].to_s
        highlight_regex = /\[\[highlight?.+\]\]/m
        summary = content.split highlight_regex
        if summary.length > 1
          content.slice!(summary[0])
          heracles_blog_post.fields[:summary].value = clean_content LegacyBlueprint::BluedownFormatter.mark_up(summary[0], subject: blueprint_daily, assetify: true)
          heracles_blog_post.fields[:intro].value = clean_content LegacyBlueprint::BluedownFormatter.mark_up(summary[0], subject: blueprint_daily, assetify: true)
        else
          # Erase any previously imported data
          heracles_blog_post.fields[:summary].value = ""
          heracles_blog_post.fields[:intro].value = ""
        end

        meta_regex = /(^\*{3}.+)(^\*{2}.+\*{2})(\W*)\z/im
        meta_matches = meta_regex.match content
        if meta_matches
          meta = ""
          meta_matches.captures.each do |match|
            meta += match.gsub(/^\*{3}\r\n/, "")
          end
          heracles_blog_post.fields[:meta].value = LegacyBlueprint::BluedownFormatter.mark_up(meta, subject: blueprint_daily, assetify: true).strip
        else
          heracles_blog_post.fields[:meta].value = ""
        end
        body = clean_content content.gsub(meta_regex, "")

        heracles_blog_post.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(body, subject: blueprint_daily, assetify: true)
        heracles_blog_post.created_at = Time.zone.parse(blueprint_daily["created_on"].to_s)
        heracles_blog_post.parent = parent
        heracles_blog_post.collection = collection
        authors = all_authors.select { |p| p.fields[:legacy_user_id].value.to_i == blueprint_daily["user_id"].to_i }
        if authors.present?
          heracles_blog_post.fields[:authors].page_ids = authors.map(&:id)
        end

        tags_for_post = blueprint_tags_for(blueprint_tag_records, blueprint_daily["id"], "TumPost")
        apply_tags_to(heracles_blog_post, tags_for_post)
        heracles_blog_post.save!
      end
    end

    # Import the quotes
    blueprint_dailies_quotes   = blueprint_records.select { |r| r.class == LegacyBlueprint::TumQuote && r["page_id"].to_i == id }
    blueprint_dailies_quotes.each do |blueprint_daily|
      attribution = blueprint_daily["content"].to_s
      quote = blueprint_daily["title"].to_s
      heracles_blog_post = Heracles::Page.find_by_slug(blueprint_daily["slug"])
      unless heracles_blog_post then heracles_blog_post = Heracles::Page.new_for_site_and_page_type(site, "blog_post") end
      heracles_blog_post.published = blueprint_daily["publish_on"].present?
      heracles_blog_post.slug = blueprint_daily["slug"]
      heracles_blog_post.title = replace_entities(attribution)

      summary = "<blockquote>#{quote}</blockquote><p>#{attribution}</p>"
      heracles_blog_post.fields[:summary].value = clean_content LegacyBlueprint::BluedownFormatter.mark_up(summary, subject: blueprint_daily, assetify: false)
      heracles_blog_post.fields[:intro].value = ""

      # Build insertable for body
      quote = ERB::Util.h(quote).gsub(/\n/, "")
      puts quote.inspect
      body = '<div contenteditable="false" insertable="pull_quote" value="{&quot;quote&quot;:&quot;'+quote+'&quot;,&quot;attribution&quot;:&quot;'+clean_content(attribution)+'&quot;}"></div>'
      heracles_blog_post.fields[:body].value = body

      heracles_blog_post.tag_list.add(["legacy-quote"])

      heracles_blog_post.created_at = Time.zone.parse(blueprint_daily["created_on"].to_s)
      heracles_blog_post.parent = parent
      heracles_blog_post.collection = collection
      tags_for_post = blueprint_tags_for(blueprint_tag_records, blueprint_daily["id"], "TumPost")
      apply_tags_to(heracles_blog_post, tags_for_post)
      heracles_blog_post.save!
    end

    # Widgets
    blueprint_dailies_widgets = blueprint_records.select { |r| r.class == LegacyBlueprint::TumWidget && r["page_id"].to_i == id }
    blueprint_dailies_widgets_settings = blueprint_records.select { |r| r.class == LegacyBlueprint::Setting && r["key"].to_s == "Summary" && r["configurable_type"].to_s == "TumPost" }
    blueprint_dailies_widgets.each do |blueprint_daily|
      heracles_blog_post = Heracles::Page.find_by_slug(blueprint_daily["slug"])
      unless heracles_blog_post then heracles_blog_post = Heracles::Page.new_for_site_and_page_type(site, "blog_post") end
      heracles_blog_post.slug = blueprint_daily["slug"]

      # Get title from LegacyBlueprint::Settings
      summary = blueprint_dailies_widgets_settings.find {|s| s["configurable_id"].to_i == blueprint_daily["id"].to_i}
      if summary and summary["value"].presence
        heracles_blog_post.title = replace_entities(summary["value"])
      else
        heracles_blog_post.title = replace_entities blueprint_daily["title"]
      end

      heracles_blog_post.fields[:summary].value = clean_content LegacyBlueprint::BluedownFormatter.mark_up(blueprint_daily["title"], subject: blueprint_daily, assetify: false)
      heracles_blog_post.fields[:intro].value = ""

      # Build insertable for body
      # Skip any with the old flowplayer markup
      old_markup_matcher = "data=\"http://wheelercentre.com/static/scripts/flowplayer.commercial"
      old_markup_regexp = Regexp.new(old_markup_matcher)
      old_markup_matches = old_markup_regexp.match blueprint_daily["content"].to_s
      if old_markup_matches
        heracles_blog_post.fields[:body].value = ""
        heracles_blog_post.tag_list.add(["legacy-widget-player"])
        # Don't publish any of these
        heracles_blog_post.published = false
      else
        content = CGI.escape_html(CGI.escape_html(blueprint_daily["content"].to_s.strip))
        body = '<div contenteditable="false" insertable="code" value="{&quot;code&quot;:&quot;'+content+'&quot;}"></div>'
        heracles_blog_post.fields[:body].value = body
        # Publish if avail
        heracles_blog_post.published = blueprint_daily["publish_on"].present?
      end

      heracles_blog_post.tag_list.add(["legacy-widget"])

      heracles_blog_post.created_at = Time.zone.parse(blueprint_daily["created_on"].to_s)
      heracles_blog_post.parent = parent
      heracles_blog_post.collection = collection
      tags_for_post = blueprint_tags_for(blueprint_tag_records, blueprint_daily["id"], "TumPost")
      apply_tags_to(heracles_blog_post, tags_for_post)
      heracles_blog_post.save!
    end
  end

  desc "Import blueprint podcast series"
  task :import_blueprint_podcast_series, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
    podcast_index = Heracles::Page.find_by_url("broadcasts/podcasts")

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_tag_records = blueprint_tags(blueprint_records)

    # Get all the settings with podcast URLs
    blueprint_podcast_url_settings_records = blueprint_records.select do |r|
      r.class == LegacyBlueprint::Setting && r["configurable_type"] == "EvtEvent" && r["key"] == "Podcast URL" && r["value"].present?
    end
    # Get all the event ids from those records
    blueprint_podcast_event_ids = blueprint_podcast_url_settings_records.map {|r| r["configurable_id"].to_i }

    # Get the actual event records
    blueprint_podcast_events_records = blueprint_records.select do |r|
      r.class == LegacyBlueprint::CenevtEvent && blueprint_podcast_event_ids.include?(r["id"].to_i)
    end
    blueprint_podcast_series_ids = blueprint_podcast_events_records.map {|r| r["program_id"].to_i }

    # Get the program records
    blueprint_podcast_series_records = blueprint_records.select do |r|
      r.class == LegacyBlueprint::CenevtProgram && blueprint_podcast_series_ids.include?(r["id"].to_i)
    end

    # Create a Podcast Series for each program record
    blueprint_podcast_series_records.each do |blueprint_podcast_series|
      if blueprint_podcast_series["name"].present?
        create_params = {
          parent: podcast_index,
          page_order_position: :last,
          published: blueprint_podcast_series["publish_on"].present?,
          slug: blueprint_podcast_series["slug"],
          title: replace_entities(blueprint_podcast_series["name"]),
          created_at: Time.zone.parse(blueprint_podcast_series["created_on"].to_s)
        }
        heracles_podcast_series = Heracles::Page.find_by_url("broadcasts/podcasts/#{blueprint_podcast_series["slug"]}")
        unless heracles_podcast_series
          result = Heracles::CreatePage.call(site: site, page_type: "podcast_series", page_params: create_params)
          heracles_podcast_series = result.page
        end

        # Associate field data
        heracles_podcast_series.fields[:legacy_program_id].value = blueprint_podcast_series["id"].to_i
        heracles_podcast_series.fields[:description].value = clean_content LegacyBlueprint::BluedownFormatter.mark_up(blueprint_podcast_series["content"], subject: blueprint_podcast_series, assetify: false)

        # Tags
        tags_for_post = blueprint_tags_for(blueprint_tag_records, blueprint_podcast_series["id"], "CenevtProgram")
        if tags_for_post.any?
          apply_tags_to(heracles_podcast_series, tags_for_post)
        end
        heracles_podcast_series.save!
      end
    end
  end

  desc "Import blueprint podcast episodes"
  task :import_blueprint_podcast_episodes, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_tag_records = blueprint_tags(blueprint_records)

    # Get all the settings with podcast URLs
    blueprint_podcast_url_settings_records = blueprint_records.select do |r|
      r.class == LegacyBlueprint::Setting && r["configurable_type"] == "EvtEvent" && r["key"] == "Podcast URL" && r["value"].present?
    end
    # Get all the event ids from those records
    blueprint_podcast_event_ids = blueprint_podcast_url_settings_records.map {|r| r["configurable_id"].to_i }

    # Get the actual event records
    blueprint_podcast_events_records = blueprint_records.select do |r|
      r.class == LegacyBlueprint::CenevtEvent && blueprint_podcast_event_ids.include?(r["id"].to_i)
    end
    blueprint_podcast_series_ids = blueprint_podcast_events_records.map {|r| r["program_id"].to_i }

    # Get the program records
    blueprint_podcast_series_records = blueprint_records.select do |r|
      r.class == LegacyBlueprint::CenevtProgram && blueprint_podcast_series_ids.include?(r["id"].to_i)
    end

    # Create a Podcast episode for each program record
    blueprint_podcast_events_records.each do |blueprint_podcast_episode|
      # Get the series
      blueprint_podcast_series = blueprint_podcast_series_records.find {|r| r["id"].to_i == blueprint_podcast_episode["program_id"].to_i }
      if blueprint_podcast_series
        heracles_podcast_series = Heracles::Page.find_by_url("broadcasts/podcasts/#{blueprint_podcast_series["slug"]}")
        heracles_podcast_series_collection = heracles_podcast_series.children.of_type("collection").first

        if blueprint_podcast_episode["title"].present?
          heracles_podcast_episode = Heracles::Page.find_by_url("broadcasts/podcasts/#{blueprint_podcast_series["slug"]}/#{blueprint_podcast_episode["slug"]}")
          unless heracles_podcast_episode
            create_params = {
              parent: heracles_podcast_series,
              collection: heracles_podcast_series_collection,
              page_order_position: :last,
              published: blueprint_podcast_episode["publish_on"].present?,
              slug: blueprint_podcast_episode["slug"],
              title: replace_entities(blueprint_podcast_episode["title"]),
              created_at: Time.zone.parse(blueprint_podcast_episode["created_on"].to_s)
            }
            result = Heracles::CreatePage.call(site: site, page_type: "podcast_episode", page_params: create_params)
            heracles_podcast_episode = result.page
          end

          # Dates
          if blueprint_podcast_episode["publish_on"].present?
            heracles_podcast_episode.fields[:publish_date].value = ActiveSupport::TimeZone["Melbourne"].parse(blueprint_podcast_episode["publish_on"])
          end

          # Associate field data
          heracles_podcast_episode.fields[:description].value = clean_content LegacyBlueprint::BluedownFormatter.mark_up(blueprint_podcast_episode["content"], subject: blueprint_podcast_episode, assetify: false)

          # Associate with event (event -> podcast episode)
          heracles_event = Heracles::Page.of_type("event").find_by_slug(blueprint_podcast_episode["slug"])
          if heracles_event
            heracles_event.fields[:podcast_episodes].page_ids = heracles_event.fields[:podcast_episodes].page_ids << heracles_podcast_episode.id
            heracles_event.save!
          end

          # Tags
          tags_for_post = blueprint_tags_for(blueprint_tag_records, blueprint_podcast_episode["id"], "CenevtEvent")
          if tags_for_post.any?
            apply_tags_to(heracles_podcast_episode, tags_for_post)
          end
          heracles_podcast_episode.save!
        end
      else
        # Podcast has URL, but no matching series
        puts "*** COULD NOT FIND SERIES FOR #{blueprint_podcast_episode["title"]}"
      end
    end
  end

  desc "Import blueprint main 'Wheeler Centre' podcast episodes"
  task :import_blueprint_main_podcast_episodes, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_tag_records = blueprint_tags(blueprint_records)
    blueprint_video_posts = blueprint_records.select { |r| r.class == LegacyBlueprint::CenvidPost }

    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
    series = Heracles::Page.find_by_url("broadcasts/podcasts/the-wheeler-centre")

    if series
      # Create a Podcast episode for each program record
      blueprint_video_posts.each do |blueprint_podcast_episode|
        heracles_podcast_series_collection = series.children.of_type("collection").first

        if blueprint_podcast_episode["title"].present?
          heracles_podcast_episode = Heracles::Page.find_by_url("broadcasts/podcasts/#{series.slug}/#{blueprint_podcast_episode["slug"]}")
          unless heracles_podcast_episode
            create_params = {
              parent: series,
              collection: heracles_podcast_series_collection,
              page_order_position: :last,
              published: blueprint_podcast_episode["publish_on"].present?,
              slug: blueprint_podcast_episode["slug"],
              title: replace_entities(blueprint_podcast_episode["title"]),
              created_at: Time.zone.parse(blueprint_podcast_episode["created_on"].to_s)
            }
            result = Heracles::CreatePage.call(site: site, page_type: "podcast_episode", page_params: create_params)
            heracles_podcast_episode = result.page
          end

          # Dates
          if blueprint_podcast_episode["publish_on"].present?
            heracles_podcast_episode.fields[:publish_date].value = ActiveSupport::TimeZone["Melbourne"].parse(blueprint_podcast_episode["publish_on"])
          end

          # Associate field data
          heracles_podcast_episode.fields[:description].value = clean_content LegacyBlueprint::BluedownFormatter.mark_up(blueprint_podcast_episode["description"], subject: blueprint_podcast_episode, assetify: false)

          # Associate with event (event -> podcast episode)
          heracles_event = Heracles::Page.of_type("event").find_by_slug(blueprint_podcast_episode["slug"])
          if heracles_event
            heracles_event.fields[:podcast_episodes].page_ids = heracles_event.fields[:podcast_episodes].page_ids << heracles_podcast_episode.id
            heracles_event.save!
          end

          # Tags
          tags_for_post = blueprint_tags_for(blueprint_tag_records, blueprint_podcast_episode["id"], "CenevtEvent")
          if tags_for_post.any?
            apply_tags_to(heracles_podcast_episode, tags_for_post)
          end
          heracles_podcast_episode.save!
        end
      end
    else
      # Podcast has URL, but no matching series
      puts "*** COULD NOT FIND MAIN SERIES"
    end
  end

  desc "Import blueprint types that map to Page"
  task :import_blueprint_types_to_page, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    blueprint_pages = blueprint_records.select { |r| r.class == LegacyBlueprint::Page || r.class == LegacyBlueprint::FaqPage || r.class == LegacyBlueprint::PslPage || r.class == LegacyBlueprint::CttPage || r.class == LegacyBlueprint::DbyPage || r.class == LegacyBlueprint::DirPage}

    blueprint_pages.each do |blueprint_page|
      # If a parent page is set in the yaml, find it and use it as the Heracles parent
      if blueprint_page["parent_page"].present?
        parent = Heracles::Page.find_by_slug(blueprint_page["parent_page"])
      end

      slug_components = blueprint_page["slug"].split("/")
      if slug_components.length > 1
        # Set the slug to be the last part of the blueprint slug
        slug = slug_components.last
        puts ("Slug: #{slug}" )
        # Find the closest parent page
        slug_components.reverse.each_with_index do |slug_component, index|
          if index > 0
            puts ("slug_component: #{slug_component}")
            parent = Heracles::Page.find_by_slug(slug_component)
            puts ("Parent: #{parent}")
          end
        end
      end

      if !slug.present?
        slug = blueprint_page["slug"]
      end

      heracles_page = Heracles::Sites::WheelerCentre::ContentPage.find_by_slug(slug)

      unless heracles_page
        site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
        heracles_page = Heracles::Page.new_for_site_and_page_type(site, "content_page")
        if parent.present?
          heracles_page.parent = parent
        end
      end

      heracles_page.published = true
      heracles_page.slug = slug
      heracles_page.title = blueprint_page["title"]
      heracles_page.created_at = Time.zone.parse(blueprint_page["created_on"].to_s)
      heracles_page.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_page["content"], subject: blueprint_page, assetify: false)
      heracles_page.save!
    end
  end

  # Example use: rake wheeler_centre:import_blueprint_types_to_body["/Users/josephinehall/Development/wheeler-centre/backup.yml","faq","FaqQuestion"]
  desc "Import blueprint types to a page body field"
  task :import_blueprint_types_to_body, [:yml_file, :page_slug, :type] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    YAML::ENGINE.yamler = 'syck'
    blueprint_records = YAML.load_stream(backup_data).instance_variable_get(:@documents)
    parent = Heracles::Sites::WheelerCentre::ContentPage.find_by_slug(args[:page_slug])
    body = ""

    if args[:type] == "FaqQuestion"
      blueprint_types = blueprint_records.select { |r| r.class == LegacyBlueprint::FaqQuestion }
      blueprint_types.map do |type|
        # TODO probably need to put some formatting or styling around each question for FAQs?
        body << LegacyBlueprint::BluedownFormatter.mark_up(type["question"], subject: type, assetify: false)
        body << LegacyBlueprint::BluedownFormatter.mark_up(type["answer"], subject: type, assetify: false)
      end
    end

    if parent.present?
      parent.fields[:body].value = body
      parent.save!
    end
  end

  desc "Import blueprint legacy 'Criticism Now' pages"
  task :import_blueprint_criticism_now, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

    # Find or initialise the Projects page
    projects = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "projects")
    projects.site = site
    projects.title = "Projects"
    projects.slug = "projects"
    projects.published = true
    projects.save!
    # Find or initialise the Criticism page
    criticism_now = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "projects/criticism-now")
    criticism_now.site = site
    criticism_now.title = "Criticism Now"
    criticism_now.slug = "criticism-now"
    criticism_now.published = true
    criticism_now.parent = projects
    criticism_now.save!

    blueprint_pages = blueprint_records.select { |r| r.class == LegacyBlueprint::TumPage }

    blueprint_pages.each do |blueprint_page|
      # The Dailies TumPage isn't part of "Criticism Now"
      unless blueprint_page["slug"] == "dailies"
        slug_components = blueprint_page["slug"].split("/")
        if slug_components.length > 1
          # Set the slug to be the last part of the blueprint slug
          slug = slug_components.last
        end

        if !slug.present?
          slug = blueprint_page["slug"]
        end

        heracles_page = Heracles::Sites::WheelerCentre::ContentPage.find_by_slug(slug)

        unless heracles_page
          site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
          heracles_page = Heracles::Page.new_for_site_and_page_type(site, "content_page")
          if criticism_now.present?
            heracles_page.parent = criticism_now
          end
        end

        heracles_page.published = true
        heracles_page.slug = slug
        heracles_page.title = blueprint_page["title"]
        heracles_page.created_at = Time.zone.parse(blueprint_page["created_on"].to_s)
        heracles_page.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_page["content"], subject: blueprint_page, assetify: false)
        heracles_page.save!

        reviews_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: heracles_page.url + "/all-reviews")
        reviews_collection.parent = heracles_page
        reviews_collection.site = site
        reviews_collection.fields[:contained_page_type].value = "review"
        reviews_collection.fields[:sort_attribute].value = "created_at"
        reviews_collection.fields[:sort_direction].value = "DESC"
        reviews_collection.title = "All Reviews"
        reviews_collection.slug = "all-reviews"
        reviews_collection.save!

        responses_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: heracles_page.url + "/all-responses")
        responses_collection.parent = heracles_page
        responses_collection.site = site
        responses_collection.fields[:contained_page_type].value = "response"
        responses_collection.fields[:sort_attribute].value = "created_at"
        responses_collection.fields[:sort_direction].value = "DESC"
        responses_collection.title = "All Responses"
        responses_collection.slug = "all-responses"
        responses_collection.save!

        id = blueprint_page["id"].to_i

        # TODO: do we need to handle the TumWidget type?
        # Find all the Tum{#types} that have the id as their page_id, and sort them into collections
        if id.present?
          blueprint_reviews = blueprint_records.select { |r| r.class == LegacyBlueprint::TumArticle && r["page_id"].to_i == id }
          blueprint_reviews.each do |blueprint_review|
            heracles_review = Heracles::Page.find_by_slug(blueprint_review["slug"])
            unless heracles_review then heracles_review = Heracles::Page.new_for_site_and_page_type(site, "review") end
            heracles_review.published = true
            heracles_review.slug = blueprint_review["slug"]
            heracles_review.title = blueprint_review["title"]
            heracles_review.created_at = Time.zone.parse(blueprint_review["created_on"].to_s)
            heracles_review.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_review["content"], subject: blueprint_review, assetify: false)
            heracles_review.parent = heracles_page
            heracles_review.collection = reviews_collection
            heracles_review.save!
          end

          blueprint_responses = blueprint_records.select { |r| r.class == LegacyBlueprint::TumQuote && r["page_id"].to_i == id }
          blueprint_responses.each do |blueprint_response|
            heracles_response = Heracles::Page.find_by_slug(blueprint_response["slug"])
            unless heracles_response then heracles_response = Heracles::Page.new_for_site_and_page_type(site, "response") end
            heracles_response.published = true
            heracles_response.slug = blueprint_response["slug"]
            # Trim the title to the first few words
            heracles_response.title = blueprint_response["title"][0..30].gsub(/\s\w+\s*$/, '...')
            # Map the Blueprint fields to better-named fields in Heracles.
            heracles_response.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_response["title"], subject: blueprint_response, assetify: false)
            # The author is stored in the content field
            heracles_response.fields[:author].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_response["content"], subject: blueprint_response, assetify: false)
            heracles_response.fields[:url].value = blueprint_response["url"]
            heracles_response.created_at = Time.zone.parse(blueprint_response["created_on"].to_s)
            heracles_response.parent = heracles_page
            heracles_response.collection = responses_collection
            heracles_response.save!
          end
        end
      end
    end
  end

  # Usage:
  # rake wheeler_centre:import_blueprint_recordings["/Users/josephinehall/Development/wheeler-centre/backup.yml","video.wheelercentre.com","/Users/josephinehall/Development/wheeler-centre/lib/video_migration/config.yml"]
  desc "Import legacy Blueprint 'CenvidPost' content to be Recordings"
  task :import_blueprint_recordings, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    require "video_migration/s3_util"
    require "video_migration/ec2_util"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_video_posts = blueprint_records.select { |r| r.class == LegacyBlueprint::CenvidPost }
    youtube_migrations_data = YAML::load(File.read("youtube_migrations.yml"))

    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
    parent = Heracles::Page.find_by_slug("broadcasts")
    collection = Heracles::Page.where(url: "broadcasts/all-recordings").first!

    blueprint_video_posts.each do |blueprint_video_post|
      if blueprint_video_post["title"].present?
        heracles_recording = Heracles::Sites::WheelerCentre::Recording.find_by_slug(blueprint_video_post["slug"])
        unless heracles_recording then heracles_recording = Heracles::Page.new_for_site_and_page_type(site, "recording") end
        heracles_recording.published = true
        puts (blueprint_video_post["slug"])
        heracles_recording.slug = blueprint_video_post["slug"]
        heracles_recording.title = blueprint_video_post["title"]
        heracles_recording.fields[:short_title].value = blueprint_video_post["title"]
        heracles_recording.fields[:description].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_video_post["description"], subject: blueprint_video_post, assetify: true)
        heracles_recording.fields[:transcript].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_video_post["transcript"], subject: blueprint_video_post, assetify: false)

        youtube_migration = youtube_migrations_data.find {|y| y[:recording_id] == blueprint_video_post["id"].to_i}
        if youtube_migration
          heracles_recording.fields[:youtube_video].value = youtube_migration[:youtube_url]
          unless heracles_recording.fields[:youtube_video].youtube.present?
            heracles_recording.fields[:youtube_video].fetch
          end
        end

        # # TODO :audio
        # # TODO :promo_image
        # # TODO check :publish_at?
        heracles_recording.fields[:recording_date].value = Time.zone.parse(blueprint_video_post["event_date"].to_s)
        heracles_recording.created_at = Time.zone.parse(blueprint_video_post["created_on"].to_s)
        heracles_recording.fields[:recording_id].value = blueprint_video_post["id"].to_i
        heracles_recording.parent = parent
        heracles_recording.collection = collection
        heracles_recording.save!
      end
    end
  end

  desc "Migrate videos to Youtube"
   task :migrate_videos, [:yml_file, :bucket_name, :video_config_file, :drop, :take, :create_instances ] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "video_migration/s3_util"
    require "video_migration/ec2_util"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    blueprint_videos = blueprint_records.select { |r| r.class == LegacyBlueprint::CenvidVideo }
    blueprint_video_posts = blueprint_records.select { |r| r.class == LegacyBlueprint::CenvidPost }
    recordings = Heracles::Page.of_type("recording").select { |r| r.fields[:recording_id].value > 462 }

    s3_util = S3Util.new(bucket_name: args[:bucket_name], config_file: args[:video_config_file])
    ec2_util = EC2Util.new(config_file: args[:video_config_file])

    if args[:create_instances]
      ec2_util.create_instances(10)
    else
      ec2_util.get_instances(10)
    end

    recordings_for_migration = recordings.drop(args[:drop].to_i).take(args[:take].to_i)

    recordings_for_migration.each_with_index do |recording, index|
      uuid = find_recording_uuid(blueprint_video_posts, recording)
      puts (uuid)

      # Find Videos that match a given Recording's :recording_id
      #videos = find_matching_videos(blueprint_videos, recording.fields[:recording_id].value)

      # Alternatively, find matching videos by matching on uuid
      videos = find_matching_videos_by_uuid(blueprint_videos, uuid)

      if videos.present?
        # Order the video by their encoding formats
        ordered_videos = encoding_formats.map! do |format|
          videos.find { |r| r["encoding_format"].to_s == format.to_s }
        end
        best_video = ordered_videos.find { |x| not x.nil? }

        puts (best_video)

        if best_video["dest_filename"]
          # Find the file in the S3 Bucket
          public_url = s3_util.find_video(best_video["dest_filename"].to_s)
          ec2_util.create_scripts(index, best_video["dest_filename"].to_s, public_url, recording)
          ec2_util.transfer_scripts(index)
          ec2_util.execute_scripts(index)
          youtube_url = ec2_util.get_youtube_url(index)

          migration_record = {
            :index => index,
            :id => recording.id,
            :slug => recording.slug,
            :recording_id => recording.fields[:recording_id].value,
            :uuid => uuid,
            :youtube_url => youtube_url
          }

          File.open("youtube_migrations.yml", "a") do |file|
            file << migration_record.to_yaml
          end

          recording.fields[:url].value = youtube_url
          recording.save!
        end
      end
    end
  end

  def find_matching_videos(data, recording_id)
    data.select { |r| r["post_id"].to_i == recording_id.to_i }
  end

  def find_matching_videos_by_uuid(data, uuid)
    data.select { |r| r["uuid"] == uuid }
  end

  def find_recording_uuid(data, recording)
    cenvid_post = data.find { |r| r["id"].to_i == recording.fields[:recording_id].value }
    puts (cenvid_post)
    cenvid_post["uuid"]
  end

  def encoding_formats
    [
      "Flash MP4 432p CBWI 800",
      "Flash MP4 432p CBWI 400",
      "Flash MP4 432p CBWI 200",
      "Flash MP4 432p CBWI",
      "Flash MP4 288p CBWI 800",
      "Flash MP4 288p CBWI 600",
      "Flash MP4 288p CBWI 400",
      "Flash MP4 288p CBWI 200",
      "Flash MP4 288p CBWI",
      "Flash Video 288p CBWI",
      "Flash MP4 288p CBWI TEST",
      "Flash Video 288p CBWI TEST",
      "MP3 CBWI",
    ]
  end

  def find_matching_staff_member(presenter, data)
    # The best we can do is match on the slug, or maybe the names.
    staff = data.select { |r| r["slug"].to_s == presenter["slug"].to_s }
    staff.first
  end

  def find_matching_user(presenter, data)
    # Find a user by matching on the name, unsure of a better way to do this
    users = data.select { |r| r["name"].to_s.downcase == presenter["name"].to_s.downcase }
    users.first
  end

  def find_matching_event_sponsorships(event, data)
    data.select { |r| r["event_id"].to_i == event["id"].to_i }
  end

  def find_unique_encoding_formats(data)
    formats = data.map do |video|
      video["encoding_format"].to_s
    end
    formats.uniq
  end

  desc "Find unique Blueprint classes"
  task :find_blueprint_classes => :environment do
    backup_root = "/Users/josephinehall/Development/wheeler-centre"
    backup_file = "#{backup_root}/backup-2014-12-18.yml"
    legacy_classes = open(backup_file).grep(/^---.*$/)
    class_names = legacy_classes.map do |class_name|
      class_name.split(":").last
    end
    puts(class_names.uniq)
  end

  desc "Find events with sponsors but without belonging to an event series"
  task :find_events_with_sponsors_sans_series, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])

    blueprint_records = YAML.load_stream(backup_data)

    blueprint_events = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtEvent}
    blueprint_sponsorships = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtSponsorship }
    puts (blueprint_events.count)

    events_sans_series = blueprint_events.select { |r| r["program_id"] == nil }
    puts (events_sans_series.count)
    events_with_sponsors = blueprint_events.map { |r| r["id"] } & blueprint_sponsorships.map { |r| r["event_id"] }
    puts (events_with_sponsors.count)
    events_sans_series_with_sponsors = events_sans_series.select {|r| events_with_sponsors.include? r["id"] }
    puts(events_sans_series_with_sponsors.count)
  end

  desc "Import blueprint assets"
  task :import_blueprint_assets => :environment do
    require "yaml"
    require "blueprint_shims"

    backup_root = "/Users/tim/Files/wheeler-centre-assets"
    backup_data_file = "#{backup_root}/backup-2014-12-18.yml"

    blueprint_assets = YAML.load_stream(File.read(backup_data_file)).select { |r| r.class == LegacyBlueprint::Asset }

    bar = ProgressBar.new(blueprint_assets.length)

    blueprint_assets.each do |blueprint_asset|
      bar.increment!
      next if Heracles::Asset.exists?(blueprint_id: blueprint_asset["id"])

      local_asset_file_path = File.join(backup_root, "assets", blueprint_asset["guid"], blueprint_asset["filename"])

      begin
        local_asset_file = File.open(local_asset_file_path)
      rescue Errno::ENOENT => e
        puts "Could not open file: #{local_asset_file_path}"
        next
      end

      tries = 3
      begin
        heracles_asset = Heracles::Asset.generate_from_io(local_asset_file, site: Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!)
      rescue => e
        if (tries -= 1) > 0
          sleep 2
          retry
        else
          raise e
        end
      rescue Timeout::Error => e
        if (tries -= 1) > 0
          sleep 2
          retry
        else
          raise e
        end
      end

      local_asset_file.close unless local_asset_file.closed?

      heracles_asset.blueprint_id               = blueprint_asset["id"]
      heracles_asset.blueprint_name             = blueprint_asset["name"]
      heracles_asset.blueprint_filename         = blueprint_asset["filename"]
      heracles_asset.blueprint_attachable_type  = blueprint_asset["attachable_type"]
      heracles_asset.blueprint_attachable_id    = blueprint_asset["attachable_id"]
      heracles_asset.blueprint_position         = blueprint_asset["position"]
      heracles_asset.blueprint_guid             = blueprint_asset["guid"]
      heracles_asset.blueprint_caption          = blueprint_asset["caption"]
      heracles_asset.blueprint_assoc            = blueprint_asset["assoc"]

      begin
        if heracles_asset.file_ext.present?
          heracles_asset.save!
        else
          puts "Missing file_ext: #{heracles_asset.inspect}"
        end
      rescue => e
        p e
        p heracles_asset
        exit
      end
    end
  end

  # You want to build up a yml file thusly:
  # File.open("wheeler-centre-assets-attributes.yml", "w+") { |f| f.write(Heracles::Asset.all.to_a.map(&:attributes).to_yaml) }

  desc "Build assets from attributes YML"
  task :build_assets_from_attributes_yml, [:yml_file_url] => :environment do |task, args|
    require "zlib"
    require "open-uri"

    gz_data   = open(args[:yml_file_url])
    gz_reader = Zlib::GzipReader.new(gz_data)
    yml_data  = gz_reader.read

    attributes = YAML.load(yml_data)

    puts "Importing assets from attributes YML"

    attributes.each do |asset_attrs|
      if !Heracles::Asset.exists?(blueprint_id: asset_attrs["blueprint_id"])
        puts asset_attrs["id"]
        Heracles::Asset.create!(asset_attrs)
      end
    end

    puts
    puts "Done!"
  end

  desc "Reprocess all assets"
  task :reprocess_all_assets => :environment do
    Heracles::Asset.order("created_at ASC").find_each do |asset|
      # Skip assets that already have the new versions
      next if !asset.image? || (asset.image? && asset.versions.include?(:itunes))

      Rails.logger.info "#{asset.id} ..."

      tries = 3
      begin
        # Reprocess the asset
        result = asset.reprocess

        if result
          Rails.logger.info "#{asset.id} done!"
        else
          Rails.logger.info "#{asset.id} failed!"
        end
      rescue => e
        if (tries -= 1) > 0
          sleep 2
          retry
        else
          # Catch all exceptions and just carry on if they still don't succeed
          # after some retries. We'll be able to repeat this task later to re-
          # process any assets that missed out due to timeouts or other
          # exceptions.
          Rails.logger.info "Exception (skipping asset): #{e}"
        end
      rescue Timeout::Error => e
        if (tries -= 1) > 0
          sleep 2
          retry
        else
          Rails.logger.info "Timeout (skipping asset): #{e}"
        end
      end
    end

    Rails.loger.info "Done!"
  end

end
