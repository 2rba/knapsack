module Knapsack
  class Report
    include Singleton

    def config(opts={})
      @config ||= opts
      @config.merge!(opts)
    end

    def save
      File.open(config[:report_path], 'w+') do |f|
        f.write(report_json)
      end
    end

    def open
      report = File.read(config[:report_path])
      JSON.parse(report)
    rescue Errno::ENOENT
      raise "Knapsack report file doesn't exist. Please generate report first!"
    end

    private

    def report_json
      Presenter.report_json
    end
  end
end
