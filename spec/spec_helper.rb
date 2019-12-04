# frozen_string_literal: true

# This file is always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require "rspec"
require "rspec/mocks"
require "messagebird"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # Makes the `description` and `failure_message` of custom matchers include
    # text for helper methods  defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object.
    mocks.verify_partial_doubles = true
  end

  # Causes shared context metadata to be inherited by the metadata hash of host
  # groups and examples, rather than triggering implicit auto-inclusion in
  # groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  # config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  # Turns deprecation warnings into errors.
  config.raise_errors_for_deprecations!

  # Use the documentation formatter for detailed output,
  # unless a formatter has already been configured
  # (e.g. via a command-line flag).
  config.default_formatter = "doc"

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 3

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end
