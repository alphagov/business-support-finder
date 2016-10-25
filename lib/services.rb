require 'gds_api/content_store'
require 'gds_api/publishing_api_v2'
require 'gds_api/rummager'

module Services
  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(
      Plek.new.find('content-store')
    )
  end

  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApiV2.new(
      Plek.new.find('publishing-api'),
      bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example'
    )
  end

  def self.rummager
    @rummager ||= GdsApi::Rummager.new(Plek.find("rummager"))
  end
end
