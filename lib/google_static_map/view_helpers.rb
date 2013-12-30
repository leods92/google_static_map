class GoogleStaticMap
  module ViewHelpers
    def google_static_map(map, options = {})
      unless map.is_a?(GoogleStaticMap)
        raise "Expecting GoogleStaticMap instance"
      end

      image_html_options = {
        size: map.size,
        alt: I18n.t("google_static_map.map"),
        class: "google-static-map"
      }.merge(options.delete(:image_html) || {})

      image = image_tag map.src(protocol: request.protocol),
                        image_html_options

      link_html_options = {
        target: "_blank"
      }.merge(options.delete(:link_html) || {})

      link_to image, map.href, link_html_options
    end
  end
end
