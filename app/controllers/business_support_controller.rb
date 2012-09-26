require 'gds_api/helpers'
require 'slimmer/headers'

class BusinessSupportController < ApplicationController
  include GdsApi::Helpers
  include Slimmer::Headers

  QUESTIONS = [
    "What is your activity or business?",
    "What stage is your business at?",
    "How is your business structured?",
    "Where is your business located?",
  ]
  ACTIONS = %w(sectors stage structure location)

  before_filter :load_artefact
  before_filter :load_and_validate_sectors, :only => [:stage, :stage_submit, :structure, :structure_submit, :location]
  before_filter :load_and_validate_stage, :only => [:structure, :structure_submit, :location]
  before_filter :load_and_validate_structure, :only => [:location]
  after_filter :send_slimmer_headers

  def start
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
      redirect_to next_params.merge(:action => 'structure', :stage => params[:stage])
    else
      redirect_to next_params.merge(:action => 'stage')
    end
  end

  def structure
    @structures = Structure.all
    setup_questions [@sectors, [@stage]]
  end

  def structure_submit
    if Structure.find_by_slug(params[:structure])
      redirect_to next_params.merge(:action => 'location', :structure => params[:structure])
    else
      redirect_to next_params.merge(:action => 'structure')
    end
  end

  def location
    @locations = Location.all
    setup_questions [@sectors, [@stage], [@structure]]
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
    p
  end

  def load_artefact
    @artefact = content_api.artefact(APP_SLUG)
  end

  def load_and_validate_sectors
    @sectors = Sector.find_by_slugs(params[:sectors].to_s.split("_"))
    if @sectors.empty?
      render :status => :not_found, :text => ""
    end
  end

  def load_and_validate_stage
    @stage = Stage.find_by_slug(params[:stage])
    unless @stage
      render :status => :not_found, :text => ""
    end
  end

  def load_and_validate_structure
    @structure = Structure.find_by_slug(params[:structure])
    unless @structure
      render :status => :not_found, :text => ""
    end
  end

  def send_slimmer_headers
    set_slimmer_headers(
      :format => 'business-support-finder'
    )
    set_slimmer_artefact(@artefact)
  end
end
