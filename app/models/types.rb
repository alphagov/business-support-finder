require 'ostruct'

class Types < OpenStruct
  HARDCODED_STAGES = {
    "finance" => "Finance, grants and loans",
    "all" => "Expertise, advice and finance"
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
  
  def imminence_slug
    
    if slug == 'finance'
      business_support_types = 'finance,grant,loan,equity'
    elsif slug == 'all'
      business_support_types = 'expertise-and-advice,recognition-award,equity,loan,finance,grant'
    else
      business_support_types = ''
    end
    business_support_types
  end

  def to_s
    name
  end
end