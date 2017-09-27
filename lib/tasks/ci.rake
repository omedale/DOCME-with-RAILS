unless Rails.env.production?
  Coveralls::RakeTask.new
  namespace :ci do
    desc 'Run all tests and generate a merged coverage report'
    task tests: [:spec, 'coveralls:push']
  end
end