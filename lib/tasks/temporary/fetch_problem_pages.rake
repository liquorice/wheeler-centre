namespace :temporary do
  desc "fetch_problem_pages"
  task fetch_problem_pages: :environment do
    # Find all the insertions... NOTHING, woohoohohohohoho
    Heracles::Site.first.pages.of_type("blog_post").tagged_with("notes").map do |page|
      insertions = Heracles::Insertion.where("inserted_key LIKE '%#{page.id}%'").count
    end

    urls = Heracles::Site.first.pages.of_type("blog_post").tagged_with("notes").map do |page|
      ActiveRecord::Base.connection.execute("select id from pages where fields_data::TEXT like '%#{page.id}%' AND type <> 'Heracles::Sites::WheelerCentre::BlogPost'").map do |r|
        page = Heracles::Page.find(r["id"])
        "http://localhost:5000#{page.absolute_url}"
      end
    end.flatten.uniq
    urls.each do |url|
      puts url
    end
  end
end
