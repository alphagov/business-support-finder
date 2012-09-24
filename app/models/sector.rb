require 'ostruct'

class Sector < OpenStruct
  HARDCODED_SECTORS = {
    "agriculture"=>"Agriculture",
    "business-and-finance"=>"Business and Finance",
    "construction"=>"Construction",
    "education"=>"Education",
    "health"=>"Health",
    "hospitality-and-catering"=>"Hospitality and Catering",
    "information-communication-and-media"=>"Information, Communication and Media",
    "manufacturing"=>"Manufacturing",
    "mining"=>"Mining",
    "real-estate"=>"Real Estate",
    "science-and-technology"=>"Science and Technology",
    "service-industries"=>"Service Industries",
    "transport-and-distribution"=>"Transport and Distribution",
    "travel-and-leisure"=>"Travel and Leisure",
    "utilities"=>"Utilities",
    "wholesale-and-retail"=>"Wholesale and Retail"
  }.map do |slug, name|
    new(:slug => slug, :name => name)
  end

  def self.all
    HARDCODED_SECTORS
  end

  def self.find_by_slugs(slugs)
    HARDCODED_SECTORS.select do |sector|
      slugs.include?(sector.slug)
    end
  end

  def to_s
    name
  end
end
