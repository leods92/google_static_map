class GoogleStaticMap
  class Defaults
    # The API has some limitations depending on the one you use.
    # Google offers free and business APIs.
    # https://developers.google.com/maps/documentation/staticmaps/#Imagesizes
    @@size = "250x300"

    # Standard map (no satellite images)
    @@kind = "m"

    @@sensor = false

    # Used when generating links to Google Maps.
    @@language = ::I18n.locale

    # If you want to change the scale dinamically based on client's
    # screen pixel density, check Retinizr, it supports Google Maps Images.
    # http://github.com/leods92/Retinizr.
    @@scale = 1

    @@marker_color = "red"

    @@location = {
      country: "Canada",
      state_acronym: nil,
      city: nil,
      address: nil
    }

    cattr_accessor(*GoogleStaticMap::ATTRIBUTES)
  end
end
