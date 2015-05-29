require 'ostruct'

class Sector < OpenStruct
  HARDCODED_SECTORS = {
    "agriculture" => "Agriculture, fishing and forestry",
    "arts-entertainment-sport" => "Arts, entertainment and sport",
    "business-and-finance" => "Financial services and business consultancy",
    "call-centers-administrative-services" => "Call centres and administrative services",
    "construction" => "Construction",
    "education" => "Education",
    "health" => "Medical, mental health, addiction and social work",
    "hospitality-and-catering" => "Accommodation and food services",
    "manufacturing" => "Manufacturing and engineering",
    "media-advertising-publishing" => "Media, advertising and publishing",
    "mining" => "Mining and quarrying",
    "motor-retail-repair-wholesale" => "Motor retail, repair and wholesale",
    "post-couriers-telecommunication" => "Post, couriers and telecommunication",
    "professional-scientific-technical" => "Professional, scientific and technical",
    "real-estate" => "Real estate, renting and property development",
    "tradespeople-cleaners-maintenance" => "Tradespeople, cleaners and maintenance",
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



