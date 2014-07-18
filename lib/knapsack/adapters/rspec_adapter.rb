module Knapsack
  module Adapters
    class RspecAdapter < BaseAdapter
      def bind_time_tracker
        ::RSpec.configure do |config|
          config.before(:each) do
            Knapsack.tracker.spec_path = RspecAdapter.spec_path
            Knapsack.tracker.start_timer
          end

          config.after(:each) do
            Knapsack.tracker.stop_timer
          end

          config.after(:suite) do
            puts Presenter.global_time
          end
        end
      end

      def bind_report_generator
        ::RSpec.configure do |config|
          config.after(:suite) do
            Knapsack.report.save
            puts Presenter.report_details
          end
        end
      end

      def bind_time_offset_warning
        ::RSpec.configure do |config|
          config.after(:suite) do
            puts Presenter.time_offset_warning
          end
        end
      end

      def self.spec_path
        example_group = ::RSpec.current_example.metadata[:example_group]
        until example_group[:parent_example_group].nil?
          example_group = example_group[:parent_example_group]
        end
        example_group[:file_path]
      end
    end
  end
end
