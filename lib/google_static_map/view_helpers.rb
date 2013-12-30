class GoogleStaticMap
  module ViewHelpers
    def google_static_map(map, options = {})
      unless map.is_a?(GoogleStaticMap)
        raise "Expecting GoogleStaticMap instance"
      end

      image = image_tag map.src(protocol: request.protocol),
                        size: map.size,
                        alt: I18n.t("google_static_map.map"),
                        class: "google-static-map"

      html_options = {
        target: "_blank"
      }.merge(options.delete(:link_html) || {})

      link_to image, map.href, html_options
    end
  end
end
