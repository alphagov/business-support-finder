require 'gds_api/helpers'
require 'slimmer/headers'

class BusinessSupportController < ApplicationController
  include GdsApi::Helpers
  include Slimmer::Headers

  before_filter :load_artefact
  before_filter :set_expiry
  after_filter :send_slimmer_headers

  def search
    @locations = Location.all
    @sectors = Sector.all
    @stages = Stage.all
    @sizes = Size.all
    @types = Type.all

    if params[:support_types] # At least one support type selected so apply the filters requested
      scheme_filter = { support_types: params[:support_types] }
      [:support_types,:location,:size,:sector,:stage].each do |key|
        params[key].present? && scheme_filter.merge!(key => params[key])
      end
      @schemes = Scheme.lookup(scheme_filter)
    elsif params[:support_types_submitted] # User has unticked everything and we should show them no schemes
      @schemes = []
    else # By default get all the schemes for first time landing on page
      @schemes = Scheme.lookup
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
end
