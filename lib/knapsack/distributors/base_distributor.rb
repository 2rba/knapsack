module Knapsack
  module Distributors
    class BaseDistributor
      attr_reader :report, :node_specs, :spec_pattern

      def initialize(args={})
        @report = args[:report] || default_report
        @ci_node_total = args[:ci_node_total] || config.ci_node_total
        @ci_node_index = args[:ci_node_index] || config.ci_node_index
        @spec_pattern = args[:spec_pattern] || config.spec_pattern
      end

      def ci_node_total
        @ci_node_total.to_i
      end

      def ci_node_index
        @ci_node_index.to_i
      end

      def specs_for_current_node
        specs_for_node(ci_node_index)
      end

      def specs_for_node(node_index)
        assign_spec_files_to_node
        post_specs_for_node(node_index)
      end

      def assign_spec_files_to_node
        default_node_specs
        post_assign_spec_files_to_node
      end

      def all_specs
        raise("Missing spec pattern for #{self.class}") unless spec_pattern
        @all_specs ||= Dir[spec_pattern]
      end

      protected

      def post_specs_for_node(node_index)
        raise NotImplementedError
      end

      def post_assign_spec_files_to_node
        raise NotImplementedError
      end

      def default_node_specs
        raise NotImplementedError
      end

      private

      def config
        Knapsack::Config
      end

      def default_report
        Knapsack.report.open
      end
    end
  end
end
