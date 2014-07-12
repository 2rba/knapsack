require 'singleton'
require_relative 'knapsack/version'
require_relative 'knapsack/config'
require_relative 'knapsack/tracker'
require_relative 'knapsack/presenter'
require_relative 'knapsack/report'
require_relative 'knapsack/allocator'
require_relative 'knapsack/task_loader'
require_relative 'knapsack/distributors/base_distributor'
require_relative 'knapsack/distributors/report_distributor'
require_relative 'knapsack/distributors/leftover_distributor'
require_relative 'knapsack/adapters/base_adapter'
require_relative 'knapsack/adapters/rspec_adapter'

module Knapsack
  class << self
    def tracker
      Knapsack::Tracker.instance
    end

    def report
      Knapsack::Report.instance
    end

    def root
      File.expand_path '../..', __FILE__
    end

    def load_tasks
      task_loader = Knapsack::TaskLoader.new
      task_loader.load_tasks
    end
  end
end
