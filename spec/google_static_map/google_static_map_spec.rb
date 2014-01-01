require 'spec_helper'

describe GoogleStaticMap do
  let(:map) { GoogleStaticMap.new }

  it { should allow_value(1).for(:href_zoom) }
  it { should allow_value(20).for(:href_zoom) }
  it { should_not allow_value(21).for(:href_zoom) }
  it { should_not allow_value(0).for(:href_zoom) }
  it { should allow_value(nil).for(:href_zoom) }
  it { should_not validate_presence_of(:href_zoom) }

  it { should allow_value(1).for(:src_zoom) }
  it { should allow_value(20).for(:src_zoom) }
  it { should_not allow_value(21).for(:src_zoom) }
  it { should_not allow_value(0).for(:src_zoom) }
  it { should allow_value(nil).for(:src_zoom) }
  it { should_not validate_presence_of(:src_zoom) }

  it { should allow_value("200x200").for(:size) }
  it { should_not allow_value(200).for(:size) }
  it { should_not allow_value("200 x 200").for(:size) }
  it { should_not allow_value("200, 200").for(:size) }

  it { should allow_value("").for(:coordinates) }
  it { should allow_value(nil).for(:coordinates) }
  it { should allow_value("-22.862197,-47.022192").for(:coordinates) }
  it { should allow_value("-22.862197, -47.022192").for(:coordinates) }
  it { should_not allow_value("-22,862197,-47,022192").for(:coordinates) }
  it { should_not allow_value("22.862197,47.022192").for(:coordinates) }

  describe ".set_defaults" do
    it "changes GoogleStaticMap::Defaults attributes" do
      GoogleStaticMap.set_defaults do |defaults|
        defaults.key = "123"
      end
      GoogleStaticMap::Defaults.key.should eq "123"
    end
  end

  describe "#src" do
    it "returns proper url" do
      map = GoogleStaticMap.new location: { city: "North Vancouver", state: "BC", address: "Lonsdale Ave, 100" }, size: "300x300", scale: 2, src_zoom: 7
      map.src.should eq "http://maps.googleapis.com/maps/api/staticmap?markers=color%3Ared%7CLonsdale+Ave%2C+100%2C+North+Vancouver%2C+Canada&scale=2&sensor=false&size=300x300&zoom=7"
    end

    it "returns url with https protocol if requested" do
      map = GoogleStaticMap.new location: { city: "North Vancouver", state: "BC", address: "Lonsdale Ave, 100" }, size: "300x300", scale: 2, src_zoom: 7
      map.src(protocol: "https://").should match /^https:\/\//
    end

    it "doesn't include nil parameters" do
      map = GoogleStaticMap.new keys: nil
      map.src.should eq "http://maps.googleapis.com/maps/api/staticmap?markers=color%3Ared%7CCanada&scale=1&sensor=false&size=250x300&zoom=3"
    end

    it "has zoom param at 15 if address was set" do
      map = GoogleStaticMap.new location: { city: "North Vancouver", address: "Lonsdale Ave" }
      map.src.should match /zoom=15/
    end

    it "has zoom param at 8 if address was not set" do
      map = GoogleStaticMap.new location: { city: "North Vancouver" }
      map.src.should match /zoom=8/
    end

    it "has zoom param at 3 if location was not set" do
      map = GoogleStaticMap.new
      map.src.should match /zoom=3/
    end

    it "can have custom zoom level" do
      map = GoogleStaticMap.new src_zoom: 20
      map.src.should match /zoom=20/
    end

    it "has default zoom param if it was set to empty string" do
      map = GoogleStaticMap.new src_zoom: ""
      map.src.should match /zoom=/
    end
  end

  describe "#href" do
    it "returns proper url" do
      map = GoogleStaticMap.new location: { city: "North Vancouver", state: "BC", address: "Lonsdale Ave, 100" }, language: "en-CA", src_zoom: 15
      map.href.should eq "https://maps.google.com/?hl=en-CA&q=Lonsdale+Ave%2C+100%2C+North+Vancouver%2C+Canada&t=m&z=17"
    end

    it "uses set language" do
      map.language = 'en'
      map.href.should match(/hl=en/)
    end

    it "uses I18n locale as language if language is not set" do
      I18n.stub locale: :"pt-BR"
      map.href.should match(/hl=pt-BR/)
    end

    it "returns url that makes Google ask for origin address and give directions" do
      map = GoogleStaticMap.new location: { city: "North Vancouver", state: "BC", address: "Lonsdale Ave, 100" }
      map.href(directions: true).should eq "https://maps.google.com/?daddr=Lonsdale+Ave%2C+100%2C+North+Vancouver%2C+Canada&hl=en&t=m&z=17"
    end
  end

  describe "#custom_attributes" do
    it "is empty hash if no custom attribute was set" do
      map = GoogleStaticMap.new location: {
        city: "North Vancouver",
        state: "BC",
        address: "Lonsdale Ave, 100"
      }
      map.custom_attributes.should eq({})
    end

    it "returns hash if custom attributes were set" do
      map = GoogleStaticMap.new location: { city: "North Vancouver", state: "BC", address: "Lonsdale Ave, 100" }, src_zoom: 3
      map.custom_attributes.should eq({ src_zoom: 3 })
    end
  end

  describe "#src_zoom=" do
    # Important as we need to perform math operations with it.
    it "converts input to integer" do
      map.src_zoom = "12"
      map.src_zoom.should eq 12
    end
  end

  describe "#href_zoom=" do
    # Important as we need to perform math operations with it.
    it "converts input to integer" do
      map.href_zoom = "12"
      map.href_zoom.should eq 12
    end
  end
end