require 'ostruct'
require 'gds_api/helpers'

class Scheme < OpenStruct
  extend GdsApi::Helpers

  def self.lookup(facets={})
    facets_hash = {}
    facets_hash << {:stages => facets[:stage]} if facets[:stage]
    facets_hash << {:business_sizes => facets[:size]} if facets[:size]
    facets_hash << {:locations => facets[:location]} if facets[:location]
    facets_hash << {:sectors => facets[:sectors].join(',')} if facets[:sectors]
    facets_hash << {:support_types => facets[:types].join(',')} if facets[:types]

    possible_schemes = imminence_api.business_support_schemes(facets_hash)

    return [] if possible_schemes["results"].empty?

    identifiers = possible_schemes["results"].map {|s| s["business_support_identifier"] }
    schemes = content_api.business_support_schemes(identifiers)

    schemes["results"].sort_by { |s| identifiers.index(s["identifier"]) }.map do |s|
      self.new(s)
    end
  end

  def initialize(artefact = {})
    super()
    if (details = artefact.delete("details"))
      details.each do |k,v|
        self.send("#{k}=", v)
      end
    end
    artefact.each do |k,v|
      self.send("#{k}=", v)
    end
  end
end
