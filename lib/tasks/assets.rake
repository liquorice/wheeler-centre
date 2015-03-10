namespace :assets do
  desc "Build the public assets with make/duo"
  task :build do
    system 'nodenv exec npm run build-production'
  end
end

Rake::Task["assets:precompile"].enhance ["assets:clobber"] do
  Rake::Task["assets:build"].invoke
end
