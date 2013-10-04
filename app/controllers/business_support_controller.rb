require 'gds_api/helpers'
require 'slimmer/headers'

class BusinessSupportController < ApplicationController
  include GdsApi::Helpers
  include Slimmer::Headers

  QUESTIONS = [
    "What is your activity or business?",
    "What stage is your business at?",
    "How many employees do you have?",
    "What type of support are you interested in?",
    "Where is your business located?",
  ]
  ACTIONS = %w(sectors stage size types location)

  before_filter :load_artefact
  before_filter :load_and_validate_sectors, :only => [:stage, :stage_submit, :size, :size_submit, :types, :types_submit, :location, :location_submit, :support_options]
  before_filter :load_and_validate_stage, :only => [:size, :size_submit, :types, :types_submit, :location, :location_submit, :support_options]
  before_filter :load_and_validate_size, :only => [:types, :types_submit, :location, :location_submit, :support_options]
  before_filter :load_and_validate_types, :only => [:location, :location_submit, :support_options]
  before_filter :load_and_validate_location, :only => [:support_options]
  before_filter :set_expiry
  after_filter :send_slimmer_headers

  def start
  end

  def search
    @schemes = Scheme.lookup
  end

  def sectors
    @sectors = Sector.all
    @picked_sectors = Sector.find_by_slugs(params[:sectors].to_s.split("_"))
    setup_questions
  end

  def stage
    @stages = Stage.all
    setup_questions [@sectors]
  end

  def stage_submit
    if Stage.find_by_slug(params[:stage])
      redirect_to next_params.merge(:action => 'size', :stage => params[:stage])
    else
      redirect_to next_params.merge(:action => 'stage')
    end
  end

  def size
    @sizes = Size.all
    setup_questions [@sectors, [@stage]]
  end

  def size_submit
    if Size.find_by_slug(params[:size])
      redirect_to next_params.merge(:action => 'types', :size => params[:size])
    else
      redirect_to next_params.merge(:action => 'size')
    end
  end

  def types
    @types = Type.all
    @picked_types = Type.find_by_slugs(params[:types].to_s.split('_'))
    setup_questions [@sectors, [@stage], [@size]]
  end

  def types_submit
    types = Type.find_by_slugs(params[:types] || [])
    if types.any?
      redirect_to next_params.merge(:action => 'location', :types => types.map(&:slug).join('_'))
    else
      redirect_to next_params.merge(:action => 'types')
    end
  end

  def location
    @locations = Location.all
    setup_questions [@sectors, [@stage], [@size], @types]
  end

  def location_submit
    if Location.find_by_slug(params[:location])
      redirect_to next_params.merge(:action => 'support_options', :location => params[:location])
    else
      redirect_to next_params.merge(:action => 'location')
    end
  end

  def support_options
    @support_options = Scheme.lookup(
      :sectors => @sectors,
      :stage => @stage,
      :size => @size,
      :types => @types,
      :location => @location
    )
    setup_questions [@sectors, [@stage], [@size], @types, [@location]]
  end

  private

  def setup_questions(answers=[])
    @current_question_number = answers.size + 1
    @completed_questions = QUESTIONS[0...(@current_question_number - 1)].zip(answers, ACTIONS)
    @current_question = QUESTIONS[@current_question_number - 1]
    @upcoming_questions = QUESTIONS[@current_question_number..-1]
  end

  def next_params
    p = {}
    p[:sectors] = @sectors.map(&:slug).join('_') if @sectors
    p[:stage] = @stage.slug if @stage
    p[:size] = @size.slug if @size
    p[:types] = @types.map(&:slug).join('_') if @types
    p
  end

  def load_artefact
    @artefact = content_api.artefact(APP_SLUG)
  end

  def load_and_validate_sectors
    @sectors = Sector.find_by_slugs(params[:sectors].to_s.split("_"))
    error_404 if @sectors.empty?
  end

  def load_and_validate_stage
    @stage = Stage.find_by_slug(params[:stage])
    error_404 unless @stage
  end

  def load_and_validate_size
    @size= Size.find_by_slug(params[:size])
    error_404 unless @size
  end

  def load_and_validate_types
    @types = Type.find_by_slugs(params[:types].to_s.split('_'))
    error_404 if @types.empty?
  end

  def load_and_validate_location
    @location = Location.find_by_slug(params[:location])
    error_404 unless @location
  end

  def send_slimmer_headers
    set_slimmer_headers(
      :format => 'finder'
    )
    set_slimmer_artefact(@artefact)
  end
end
