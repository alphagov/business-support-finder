require 'ostruct'
require 'gds_api/helpers'

class Scheme < OpenStruct
  extend GdsApi::Helpers

  def self.lookup(facets)
    possible_schemes = imminence_api.business_support_schemes(
      :sectors => facets[:sectors].map(&:slug).join(','),
      :stages => facets[:stage].slug,
      :business_types => facets[:structure].slug,
      :locations => facets[:location].slug
    )
    return [] if possible_schemes["results"].empty?
    schemes = content_api.business_support_schemes(possible_schemes["results"].map {|s| s["business_support_identifier"] } )

    schemes["results"].map do |s|
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
