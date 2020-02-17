desc "Run `rake spec` for each bundled engine"
task :spec do
  engine_rspec_statuses = []

  Dir["*/spec"].each do |engine_specs|
    engine_dir = engine_specs.sub("/spec", "")

    sh "cd #{engine_dir} && rake spec" do |ok, res|
      engine_rspec_statuses << res
    end
  end

  # Return the highest exist status from the rspec runs. This ensures that a
  # "failed" exit status is returned if any of the rspec runs failed.
  exit engine_rspec_statuses.map(&:exitstatus).max
end
