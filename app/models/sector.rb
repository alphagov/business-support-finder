require 'ostruct'

class Sector < OpenStruct
  HARDCODED_SECTORS = [
    "Agriculture",
    "Business and Finance",
    "Construction",
    "Education",
    "Health",
    "Hospitality and Catering",
    "Information, Communication and Media",
    "Manufacturing",
    "Mining",
    "Real Estate",
    "Science and Technology",
    "Service Industries",
    "Transport and Distribution",
    "Travel and Leisure",
    "Utilities",
    "Wholesale and Retail",
  ]

  def self.all
    HARDCODED_SECTORS.map do |name|
      new(:slug => name.parameterize, :name => name)
    end
  end
end
