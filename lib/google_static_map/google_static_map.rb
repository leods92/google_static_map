class GoogleStaticMap
  include ActiveModel::Validations

  SRC_BASE_URL = "maps.googleapis.com/maps/api/staticmap"
  HREF_BASE_URL = "maps.google.com"

  ATTRIBUTES = [
    :size,
    :kind,
    :sensor,
    :language,
    :scale,
    :marker_color,
    :location,
    :key,
    :src_zoom,
    :href_zoom,
    :coordinates
  ]

  # Check #custom_attributes.
  CUSTOM_MAP_ATTRIBUTES = [
    :src_zoom,
    :coordinates
  ]

  attr_accessor(*ATTRIBUTES)

  validates :size, format: { with: /[0-9]+x[0-9]/ }

  with_options numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 20,
    allow_nil: true
  } do |g|
    g.validates :src_zoom
    g.validates :href_zoom
  end

  validates :coordinates, format: {
    # TODO: improve this validation, x should not be
    # greater than 180 and y not greater than 90
    with: /((\+|\-)?[0-9]{1,3}\.[0-9]+,? ?){2}/,
    allow_blank: true
  }

  def self.set_defaults
    yield Defaults
  end

  def location=(location_info = {})
    # Filter accepted attributes.
    location_info.slice! :country, :state_acronym, :city, :address

    # Merge defaults with input info and set them.
    @location = Defaults.location.merge(location_info).with_indifferent_access
  end

  def src_zoom=(input)
    @src_zoom = input.to_i if input.present?
  end

  def href_zoom=(input)
    @href_zoom = input.to_i if input.present?
  end

  # In case you want to save attributes that are specific to the
  # map instance this method will help you.
  def custom_attributes
    base = {}.with_indifferent_access

    CUSTOM_MAP_ATTRIBUTES.inject(base) do |hash, attribute|
      value = send(attribute)

      # Using #blank? as coordinates might be an empty array.
      hash[attribute] = value unless value.blank?

      hash
    end
  end

  # Use this to display images.
  # This should use the same protocol used in the page it's placed in.
  # Otherwise browsers might not display image or display errors.
  def src(options = {})
    protocol = options[:protocol] == "https://" ? "https" : "http"
    "#{protocol}://#{SRC_BASE_URL}?" + src_options.to_query
  end

  # Use this to generate links.
  # This should always use HTTPS protocol to prevent unecessary redirections.
  # Option :directions is a boolean and determines whether Google Maps should
  # ask for origin so it can give directions.
  def href(options = {})
    "https://#{HREF_BASE_URL}/?" + href_options(options[:directions]).to_query
  end

  private

  def initialize(attributes = {})
    attributes = attributes.with_indifferent_access

    ATTRIBUTES.each do |attribute|
      default = Defaults.send(attribute) if Defaults.respond_to?(attribute)
      value = attributes[attribute] || default
      send "#{attribute}=", value
    end
  end

  def nilless_hash(hash)
    hash.delete_if { |k, value| value.nil? }
  end

  def src_options
    nilless_hash({
      key:     key,
      markers: marker, # Google uses "markers" not "marker"
      zoom:    src_zoom || auto_src_zoom,
      size:    size,
      sensor:  sensor,
      scale:   scale
    })
  end

  def href_options(directions = false)
    options = {
      z:   href_zoom || auto_href_zoom,
      hl:  language || auto_language,
      t:   kind
    }
    options[directions ? :daddr : :q] = coordinates || location_s

    nilless_hash(options)
  end

  def marker
    "color:#{marker_color}|#{coordinates || location_s}"
  end

  def auto_language
    I18n.locale
  end

  def auto_src_zoom
    if location[:address] || coordinates
      15
    elsif location[:city]
      8
    else
      3 # Used when displaying the whole country
    end
  end

  def auto_href_zoom
    ref_zoom = src_zoom || auto_src_zoom

    # If src_zoom gives a far perspective of a location we don't
    # wan't to increase it in Google Maps link as we probably want
    # to show a far perspective in all contexts.
    ref_zoom <= 3 ? ref_zoom : ref_zoom + 2
  end

  # An array is created to order location's information
  # the way it's necessary for Google to find the location.
  # Then, we remove any nil values that may exist.
  # Finally, we make a string separating each piece of info with a comma.
  def location_s
    # Order matters.
    [
      location[:address],
      location[:city],
      location[:state_acronym],
      location[:country]
    ].compact.join(", ")
  end
end
