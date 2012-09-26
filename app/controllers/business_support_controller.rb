require 'gds_api/helpers'
require 'slimmer/headers'

class BusinessSupportController < ApplicationController
  include GdsApi::Helpers
  include Slimmer::Headers

  QUESTIONS = [
    "What is your activity or business?",
    "What stage is your business at?",
    "How is your business structured?",
    "Where will you be located?",
  ]
  ACTIONS = %w(sectors)

  before_filter :load_artefact
  before_filter :load_and_validate_sectors, :only => [:stage, :stage_submit]
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
    next_params = {:sectors => @sectors.map(&:slug).join('_')}
    if Stage.find_by_slug(params[:stage])
      redirect_to next_params.merge(:action => 'structure', :stage => params[:stage])
    else
      redirect_to next_params.merge(:action => 'stage')
    end
  end

  private

  def setup_questions(answers=[])
    @current_question_number = answers.size + 1
    @completed_questions = QUESTIONS[0...(@current_question_number - 1)].zip(answers, ACTIONS)
    @current_question = QUESTIONS[@current_question_number - 1]
    @upcoming_questions = QUESTIONS[@current_question_number..-1]
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

  def send_slimmer_headers
    set_slimmer_headers(
      :format => 'business-support-finder'
    )
    set_slimmer_artefact(@artefact)
  end
end
