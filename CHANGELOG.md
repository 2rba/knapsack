### unreleased

* TODO

### 1.0.0

* Add cucumber support.
* Rename environment variable KNAPSACK_SPEC_PATTERN to KNAPSACK_TEST_FILE_PATTERN.
* Default name of knapsack report json file is based on adapter name so for RSpec the default report name is `knapsack_rspec_report.json` and for Cucumber the report name is `knapsack_cucumber_report.json`.

### 0.5.0

* Allow passing arguments to rspec via knapsack:rspec task.

### 0.4.0

* Add support for RSpec 2.

### 0.3.0

* Add support for semaphoreapp.com thread ENV variables.

### 0.2.0

* Add knapsack logger. Allow to use custom logger.

### 0.1.4

* Fix wrong time presentation for negative seconds.

### 0.1.3

* Better time presentation instead of seconds.

### 0.1.2

* Fix case when someone removes spec file which exists in knapsack report.
* Extract config to separate class and fix wrong node time execution on CI.

### 0.1.1

* Fix assigning time execution to right spec file when call RSpec shared example.

### 0.1.0

* Gem ready to use it!

### 0.0.3

* Test release. Not ready to use it.
