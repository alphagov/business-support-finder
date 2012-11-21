require 'gds_api/helpers'
require 'slimmer/headers'

class BusinessSupportController < ApplicationController
  include GdsApi::Helpers
  include Slimmer::Headers

  before_filter :load_artefact
  before_filter :load_all_facets, :only => :support_options
  before_filter :set_expiry, :only => [:start, :support_options]
  after_filter :send_slimmer_headers

  def start
    
  end

  def filter_submit
    p = {:action => 'support_options'}
    p[:locations] = params[:locations].join('_') if params[:locations]
    p[:sectors] = params[:sectors].join('_') if params[:sectors]
    p[:stages] = params[:stages].join('_') if params[:stages]
    p[:structures] = params[:structures].join('_') if params[:structures]
    p[:types] = params[:types].join('_') if params[:types]
    redirect_to p 
  end

  def support_options
    load_and_validate_filters
    @support_options = Scheme.lookup(
      :sectors => @sector_filters,
      :stages => @stage_filters,
      :structures => @structure_filters,
      :types => @type_filters,
      :locations => @location_filters
    )
  end

  private

  def load_artefact
    @artefact = content_api.artefact(APP_SLUG)
  end

  def load_all_facets
    @sectors = Sector.all
    @locations = Location.all
    @stages = Stage.all
    @structures = Structure.all
    @types = Type.all
  end

  def load_and_validate_filters
    load_and_validate_sectors
    load_and_validate_stages
    load_and_validate_structures
    load_and_validate_types
    load_and_validate_locations
  end

  def load_and_validate_sectors
    @sector_filters = Sector.find_by_slugs(params[:sectors].to_s.split("_"))
  end

  def load_and_validate_stages
    @stage_filters = Stage.find_by_slugs(params[:stages].to_s.split("_"))
  end

  def load_and_validate_structures
    @structure_filters = Structure.find_by_slugs(params[:structures].to_s.split("_"))
  end

  def load_and_validate_types
    @type_filters = Type.find_by_slugs(params[:types].to_s.split('_'))
  end

  def load_and_validate_locations
    @location_filters = Location.find_by_slugs(params[:locations].to_s.split("_"))
  end

  def send_slimmer_headers
    set_slimmer_headers(
      :format => 'finder'
    )
    set_slimmer_artefact(@artefact)
  end
end
