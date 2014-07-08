module Knapsack
  class Distributor
    attr_reader :report, :ci_node_total, :ci_node_index, :node_specs

    DEFAULT_CI_NODE_TOTAL = 1
    DEFAULT_CI_NODE_INDEX = 0

    def initialize(args={})
      @report = args[:report] || default_report
      @ci_node_total = args[:ci_node_total] || DEFAULT_CI_NODE_TOTAL
      @ci_node_index = args[:ci_node_index] || DEFAULT_CI_NODE_INDEX
      @not_assigned_spec_files = []
      set_node_specs
    end

    def default_report
      Knapsack.report.open
    end

    def sorted_report
      @sorted_report ||= report.sort_by{|k,v| v}.reverse
    end

    def total_time_execution
      @total_time_execution ||= report.values.reduce(0, :+).to_f
    end

    def node_time_execution
      @node_time_execution ||= total_time_execution / ci_node_total
    end

    def assign_spec_files_to_node
      assign_slow_spec_files
      assign_remaining_spec_files
    end

    private

    def assign_slow_spec_files
      node_index = 0
      sorted_report.each do |spec_file_with_time|
        time = spec_file_with_time[1]

        time_left = node_specs[node_index][:time_left] - time
        if time_left >= 0 or node_specs[node_index][:spec_files_with_time].empty?
          node_specs[node_index][:time_left] -= time
          node_specs[node_index][:spec_files_with_time] << spec_file_with_time
        else
          @not_assigned_spec_files << spec_file_with_time
        end

        node_index += 1
        node_index = 0 if node_index == ci_node_total
      end
    end

    def assign_remaining_spec_files
      @not_assigned_spec_files.each do |spec_file_with_time|
        time = spec_file_with_time[1]
        node_specs[node_with_max_time_left][:spec_files_with_time] << spec_file_with_time
        node_specs[node_with_max_time_left][:time_left] -= time
      end
    end

    def node_with_max_time_left
      node_spec = node_specs.max { |a,b| a[:time_left] <=> b[:time_left] }
      node_spec[:node_index]
    end

    def set_node_specs
      @node_specs = []
      ci_node_total.times do |index|
        @node_specs << {
          node_index: index,
          time_left: node_time_execution,
          spec_files_with_time: []
        }
      end
    end
  end
end
