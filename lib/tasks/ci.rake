unless Rails.env.production?
  namespace :ci do
    desc 'Run all tests and generate a merged coverage report'
    task tests: [:spec]
  end
end