require 'gds_api/helpers'

class Scheme
  extend GdsApi::Helpers

  def self.lookup(facets)
    business_support_api.schemes(facets)
  end
end
