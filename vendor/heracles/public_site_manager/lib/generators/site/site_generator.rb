class SiteGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def generate_site
    templates_dir = File.expand_path('../templates/', __FILE__)
    files = Dir.glob(File.join(templates_dir, '**', '*'), File::FNM_DOTMATCH).reject { |f| File.directory?(f) }

    files.each do |file|
      file.slice! "#{templates_dir}/"
      new_file = file.gsub(/\bsite_template\b/, snake_case_site_name)
      template file, "#{site_dir}/#{new_file}"
    end
  end

  private

  def site_dir
    "sites/#{snake_case_site_name}"
  end

  def snake_case_site_name
    name.underscore
  end

  def camel_case_site_name
    name.camelize
  end
end
