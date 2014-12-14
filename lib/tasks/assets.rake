namespace :assets do
  desc "Build the public assets with make/duo"
  task :build do
    system 'make build'
  end
end

Rake::Task["assets:precompile"].enhance do
  Rake::Task["assets:build"].invoke
end
