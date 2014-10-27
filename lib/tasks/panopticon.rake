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
        title: "Finance and support for your business",
        description: "Find business finance, support, grants and loans backed by the government.",
        need_id: "100115",
        paths: [],
        prefixes: ["/#{APP_SLUG}"],
        state: "live",
        indexable_content: "Business finance and support finder")
    registerer.register(record)
  end
end
