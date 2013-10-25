require 'ostruct'
require 'gds_api/helpers'

class Scheme < OpenStruct
  extend GdsApi::Helpers

  def self.lookup(facets={})
    facets_hash = {}
    facets_hash[:stages] = facets[:stage] if facets[:stage]
    facets_hash[:business_sizes] = facets[:size] if facets[:size]
    facets_hash[:locations] = facets[:location] if facets[:location]
    facets_hash[:sectors] = facets[:sector] if facets[:sector]
    facets_hash[:support_types] = facets[:support_types].join(',') if facets[:support_types]

    possible_schemes = imminence_api.business_support_schemes(facets_hash)

    return [] if possible_schemes["results"].empty?

    identifiers = possible_schemes["results"].map {|s| s["business_support_identifier"] }
    schemes = content_api.business_support_schemes(identifiers)

    schemes["results"].sort_by { |s| identifiers.index(s["identifier"]) }.map do |s|
      imminence_data_for_scheme = possible_schemes["results"].find{ |data| data["business_support_identifier"] == s["identifier"] }
      facets_for_scheme = {}
      [:business_sizes, :locations, :sectors, :stages, :support_types].each do |k|
        facets_for_scheme[k] = imminence_data_for_scheme[k.to_s]
      end
      s = s.merge(facets_for_scheme)
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
