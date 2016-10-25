class BusinessSupportController < ApplicationController

  before_filter :load_content_item
  before_filter :set_expiry
  before_filter :prepare_facets

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

  def load_content_item
    @content_item = Services.content_store.content_item("/#{APP_SLUG}").to_hash
    # Remove the organisations from the content item - this will prevent the
    # govuk:analytics:organisations meta tag from being generated until there is
    # a better way of doing this.
    if @content_item["links"]
      @content_item["links"].delete("organisations")
    end

    @navigation_helpers = GovukNavigationHelpers::NavigationHelper.new(@content_item)
    section_name = @content_item.dig("links", "parent", 0, "title")
    if section_name
      @meta_section = section_name.downcase
    end
  end

  def prepare_facets
    @facets = {}
    if params[:postcode].present?
      @facets[:postcode] = params[:postcode].gsub(/[^\w\s]/i, '').strip
    end
    @facets[:support_types] = params[:support_types].join(',') if params[:support_types]
    @facets[:business_sizes] = params[:business_sizes] if params[:business_sizes].present?
    @facets[:sectors] = params[:sectors] if params[:sectors].present?
    @facets[:stages] = params[:stages] if params[:stages].present?
  end
end
