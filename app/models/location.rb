require 'ostruct'

class Location < OpenStruct
  HARDCODED_DATA = {
    "england" => "England",
    "scotland" => "Scotland",
    "wales" => "Wales",
    "northern-ireland" => "Northern Ireland",
  }.map do |slug, name|
    new(:slug => slug, :name => name)
  end

  def self.all
    HARDCODED_DATA
  end

  def self.find_by_slugs(slugs)
    HARDCODED_DATA.select do |location|
      slugs.include?(location.slug)
    end
  end

  def to_s
    name
  end
end
