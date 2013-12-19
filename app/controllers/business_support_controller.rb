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
    @locations = Location.all
    @sectors = Sector.all
    @stages = Stage.all
    @sizes = Size.all
    @types = Type.all

    if params[:support_types] # At least one support type selected so apply the filters requested
      @schemes = business_support_api.schemes(@facets)
    elsif params[:support_types_submitted] # User has unticked everything and we should show them no schemes
      @schemes = []
    else # By default get all the schemes for first time landing on page
      @schemes = business_support_api.schemes
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
    @facets[:support_types] = params[:support_types].join(',') if params[:support_types]
    @facets[:business_sizes] = params[:size] if params[:size].present?
    @facets[:locations] = params[:location] if params[:location].present?
    @facets[:sectors] = params[:sector] if params[:sector].present?
    @facets[:stages] = params[:stage] if params[:stage].present?
  end
end
