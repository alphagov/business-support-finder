require 'ostruct'

class Location < OpenStruct
  HARDCODED_DATA = {
    "england" => "England",
    "london" => "London",
    "north-east" => "North East (England)",
    "north-west" => "North West (England)",
    "east-midlands" => "East Midlands (England)",
    "west-midlands" => "West Midlands (England)",
    "yorkshire-and-the-humber" => "Yorkshire and the Humber",
    "south-west" => "South West (England)",
    "east-of-england" => "East of England",
    "south-east" => "South East (England)",
    "scotland" => "Scotland",
    "wales" => "Wales",
    "northern-ireland" => "Northern Ireland",
  }.map do |slug, name|
    new(:slug => slug, :name => name)
  end

  def self.all
    HARDCODED_DATA
  end

  def self.find_by_slug(slug)
    HARDCODED_DATA.find do |stage|
      stage.slug == slug
    end
  end

  def to_s
    name
  end
end
