require 'ostruct'

class Sector < OpenStruct
  HARDCODED_SECTORS = {
    "agriculture" => "Agriculture, fishing and forestry",
    "business-and-finance" => "Financial services and business consultancy",
    "construction" => "Construction",
    "education" => "Education",
    "health" => "Medical, mental health, addiction and social work",
    "hospitality-and-catering" => "Accommodation and food services",
    "manufacturing" => "Manufacturing and engineering",
    "mining" => "Mining and quarrying",
    "real-estate" => "Real estate, renting and property development",
    "science-and-technology" => "Research and development",
    "transport-and-distribution" => "Transport, travel, storage and distribution",
    "utilities" => "Electricity, gas and water supply",
    "wholesale-and-retail" => "Wholesale, retail and repairs"
  }.map do |slug, name|
    new(:slug => slug, :name => name)
  end

  def self.all
    HARDCODED_SECTORS
  end

end



