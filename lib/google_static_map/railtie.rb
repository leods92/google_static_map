class GoogleStaticMap
  class Railtie < Rails::Railtie
    initializer "google_static_map.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end