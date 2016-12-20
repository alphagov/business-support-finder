require 'ostruct'

class Stage < OpenStruct
  HARDCODED_STAGES = {
    "pre-start" => "Pre-start",
    "start-up" => "Start-up",
    "grow-and-sustain" => "Grow and sustain"
  }.map do |slug, name|
    new(slug: slug, name: name)
  end

  def self.all
    HARDCODED_STAGES
  end
end
