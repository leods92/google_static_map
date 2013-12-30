require 'google_static_map'
require 'shoulda-matchers'

spec_dir = File.dirname(__FILE__)

# Requires supporting ruby files with custom matchers,
# macros, shared examples, etc.
Dir["#{spec_dir}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Assures class variables are reloaded to their initial values.
  config.before(:each) do
    GoogleStaticMap.send(:remove_const, :Defaults)
    load "#{spec_dir}/../lib/google_static_map/defaults.rb"
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Allows us to execute only onle spec example by passing
  # focus: true to example definition
  # http://railscasts.com/episodes/285-spork
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
