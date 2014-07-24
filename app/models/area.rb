require 'ostruct'
require "gds_api/helpers"

class Area < OpenStruct

  extend GdsApi::Helpers

  def self.all
    countries.map do |c|
      c.regions = regions(c)
      c
    end
  end

  def self.countries
    areas.select { |a| a.name == a.country_name }
  end

  def self.areas
    @areas ||= imminence_areas
  end

  private

  def self.regions(country)
    regions = areas.select { |a| !countries.include?(a) and country.name == a.country_name }
    regions.sort! { |x,y| x.name <=> y.name }
    all_of = country.clone
    all_of.name = "All of #{country.name}"
    regions.unshift all_of
  end

  def self.imminence_areas
    imminence_api.areas_for_type("EUR")["results"].map do |area_hash|
      self.new(area_hash)
    end
  end

end
