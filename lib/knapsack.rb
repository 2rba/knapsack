require 'knapsack/version'
require 'singleton'

module Knapsack
  class << self
    def tracker
      Knapsack::Tracker.instance
    end
  end

  class Tracker
    include Singleton

    attr_reader :global_time, :files

    def initialize
      return unless enabled?
      @global_time = 0
      @files = {}
      start
    end

    def enabled?
      ENV['KNAPSACK_TRACKER_ENABLED'] || false
    end

    def start
      puts 'Knapsack started!'

      RSpec.configure do |config|
        config.before(:each) do
          Knapsack.tracker.start_timer
        end

        config.after(:each) do
          puts "Stop time: " + Knapsack.tracker.stop_timer.to_s
          puts "Global time: " + Knapsack.tracker.global_time.to_s
        end

        config.after(:suite) do
          puts "Files:"
          puts Knapsack.tracker.files
        end
      end
    end

    def start_timer
      @start_time = Time.now.to_f
    end

    def stop_timer
      @execution_time = Time.now.to_f - @start_time
      @global_time += @execution_time
      update_time_for_spec_file
      @execution_time
    end

    def update_time_for_spec_file
      file_path = RSpec.current_example.metadata[:example_group][:file_path]
      @files[file_path] ||= 0
      @files[file_path] += @execution_time
    end
  end
end
