require 'gds_api/helpers'
require 'slimmer/headers'

class BusinessSupportController < ApplicationController
  include GdsApi::Helpers
  include Slimmer::Headers

  before_filter :load_artefact
  after_filter :send_slimmer_headers

  def start
  end

  private

  def load_artefact
    @artefact = content_api.artefact(APP_SLUG)
  end

  def send_slimmer_headers
    set_slimmer_headers(
      :format => 'business-support-finder'
    )
    set_slimmer_artefact(@artefact)
  end
end
