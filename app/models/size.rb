require 'ostruct'

class Size < OpenStruct
  HARDCODED_DATA = {
    "under-10" => "Under 10",
    "up-to-249" => "Up to 249",
    "between-250-and-500" => "Between 250 and 500",
    "between-501-and-1000" => "Between 501 and 1000",
    "over-1000" => "Over 1000"
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
