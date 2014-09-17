require 'gds_api/helpers'
require 'slimmer/headers'

class BusinessSupportController < ApplicationController
  include GdsApi::Helpers
  include Slimmer::Headers

  before_filter :load_artefact
  before_filter :set_expiry
  before_filter :prepare_facets
  after_filter :send_slimmer_headers

  def search
    @sectors = Sector.all
    @stages = Stage.all
    @sizes = Size.all
    @types = Type.all
    if @facets.empty? and params[:commit]
      @schemes = []
    else
      @schemes = Scheme.lookup(@facets)
    end
  end

  private

  def load_artefact
    @artefact = content_api.artefact(APP_SLUG)
  end

  def send_slimmer_headers
    set_slimmer_headers(
      :format => 'finder'
    )
    set_slimmer_artefact(@artefact)
  end

  def prepare_facets
    @facets = {}
    @facets[:postcode] = params[:postcode] if params[:postcode].present?
    @facets[:support_types] = params[:support_types].join(',') if params[:support_types]
    @facets[:business_sizes] = params[:business_sizes] if params[:business_sizes].present?
    @facets[:sectors] = params[:sectors] if params[:sectors].present?
    @facets[:stages] = params[:stages] if params[:stages].present?
  end
end
