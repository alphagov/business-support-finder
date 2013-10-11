require 'ostruct'

class Size < OpenStruct
  HARDCODED_DATA = {
    "0-10" => "0 - 9",
    "11-249" => "10 - 249",
    "250-499" => "250 - 499",
    "500-999" => "500 - 999",
    "over-1000" => "1000+"
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
