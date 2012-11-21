require 'ostruct'

class Stage < OpenStruct
  HARDCODED_STAGES = {
    "pre-startup" => "Pre-startup",
    "start-up" => "Start-up",
    "grow-and-sustain" => "Grow and sustain",
    "exiting-a-business" => "Exiting a business",
  }.map do |slug, name|
    new(:slug => slug, :name => name)
  end

  def self.all
    HARDCODED_STAGES
  end

  def self.find_by_slugs(slugs)
    HARDCODED_STAGES.select do |stage|
      slugs.include?(stage.slug)
    end
  end

  def to_s
    name
  end
end
