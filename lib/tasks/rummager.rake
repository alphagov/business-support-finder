namespace :rummager do
  desc "Indexes the business support page in Rummager"
  task index: :environment do
    require 'gds_api/rummager'

    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }

    business_support_page = OpenStruct.new(BusinessSupportPage::DATA)
    logger.info "Indexing '#{business_support_page.title}' in rummager..."

    SearchIndexer.call(business_support_page)
  end
end
