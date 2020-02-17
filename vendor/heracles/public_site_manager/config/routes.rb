Heracles::PublicSiteManager::Engine.routes.draw do
  begin
    Heracles::Site.servable.each do |site|
      scope module: site.engine_path, constraints: Heracles::PublicSiteManager::SiteHostConstraint.new(site) do
        mount site.engine, at: "/"
      end
    end
  rescue => e
    puts "* Error loading public site routes: #{e.message}"
  end
end
