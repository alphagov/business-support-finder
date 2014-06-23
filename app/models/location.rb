require "ostruct"

class Location < OpenStruct
  HARDCODED_DATA = {
    "England" => {
      "england" => "All of England",
      "london" => "London",
      "north-east" => "North East",
      "north-west" => "North West",
      "east-midlands" => "East Midlands",
      "west-midlands" => "West Midlands",
      "yorkshire-and-the-humber" => "Yorkshire and the Humber",
      "south-west" => "South West",
      "east-of-england" => "East of England",
      "south-east" => "South East",
    },
    "Scotland" => { "scotland" => "All of Scotland" },
    "Wales" => { "wales" => "All of Wales" },
    "Northern Ireland" => { "northern-ireland" => "All of Northern Ireland" },
  }.map do |name, regions|
    new(name: name, regions: regions.map { |slug, name|
      new(slug: slug, name: name)
    })
  end

  def self.all
    HARDCODED_DATA
  end

end
