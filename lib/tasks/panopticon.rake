require 'ostruct'

namespace :panopticon do
  desc "Register application metadata with panopticon"
  task :register => :environment do
    require 'gds_api/panopticon'
    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }
    logger.info "Registering with panopticon..."

    registerer = GdsApi::Panopticon::Registerer.new(owning_app: "businesssupportfinder")

    record = OpenStruct.new(
        slug: APP_SLUG,
        title: "Business finance and support finder",
        description: "Search for publicly-backed finance or support schemes based on basic information about your business including location and type",
        need_id: "B1017",
        prefixes: [APP_SLUG],
        state: "live",
        indexable_content: "Business finance and support finder")
    registerer.register(record)
  end
end
