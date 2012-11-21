require 'ostruct'
require 'gds_api/helpers'

class Scheme < OpenStruct
  extend GdsApi::Helpers

  def self.lookup(facets)
    facet_criteria = {}
    facet_criteria[:business_types] = facets[:structures].map(&:slug).join(',') unless facets[:structures].empty?
    facet_criteria[:locations] = facets[:locations].map(&:slug).join(',') unless facets[:locations].empty?
    facet_criteria[:sectors] = facets[:sectors].map(&:slug).join(',') unless facets[:sectors].empty?
    facet_criteria[:stages] = facets[:stages].map(&:slug).join(',') unless facets[:stages].empty?
    facet_criteria[:types] = facets[:types].map(&:slug).join(',') unless facets[:types].empty?
    
    possible_schemes = imminence_api.business_support_schemes(facet_criteria)
 
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
