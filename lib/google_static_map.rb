require 'active_support/all'
require 'active_model'

lib_dir = File.dirname(__FILE__)

require "#{lib_dir}/google_static_map/google_static_map.rb"

class GoogleStaticMap
  autoload :Defaults,    'google_static_map/defaults'
  autoload :ViewHelpers, 'google_static_map/view_helpers'
end

I18n.load_path = Dir["#{lib_dir}/config/locales/*.yml"]
I18n.enforce_available_locales = true
I18n.backend.load_translations

require 'google_static_map/railtie' if defined?(Rails)
