namespace :assets do
  task :install do
    system 'npm install'
  end
  desc "Build the public assets with make/duo"
  task :build do
    system 'make build'
  end
end

Rake::Task["assets:precompile"].enhance ["assets:install"] do
  Rake::Task["assets:build"].invoke
end
