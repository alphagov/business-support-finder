require 'ostruct'

class Structure < OpenStruct
  HARDCODED_STAGES = {
    "private-company" => "Private company",
    "partnership" => "Partnership",
    "public-limited-company" => "Public limited company",
    "sole-trader" => "Sole trader",
    "social-enterprise" => "Social enterprise",
    "charity" => "Charity",
  }.map do |slug, name|
    new(:slug => slug, :name => name)
  end

  def self.all
    HARDCODED_STAGES
  end

  def self.find_by_slug(slug)
    HARDCODED_STAGES.find do |stage|
      stage.slug == slug
    end
  end

  def to_s
    name
  end
end
