require 'knapsack'
Knapsack.tracker.config({
  enable_time_offset_warning: true,
  time_offset_in_seconds: 3
})
Knapsack.report.config({
  report_path: 'knapsack_report.json'
})
Knapsack::Adapters::RspecAdapter.bind

RSpec.configure do |config|
  config.order = :random
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
