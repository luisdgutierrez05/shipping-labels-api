SimpleCov.configure do
  add_filter '/vendor/cache/'
  add_group 'Poor Coverage', nil do |source_file|
    source_file.covered_percent <= 80
  end
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
end

SimpleCov.merge_timeout 3600
SimpleCov.use_merging true
