class SearchIndexer
  attr_reader :business_support_page
  delegate :slug, to: :business_support_page

  def initialize(business_support_page)
    @business_support_page = business_support_page
  end

  def self.call(business_support_page)
    new(business_support_page).call
  end

  def call
    Services.rummager.add_document(document_type, document_id, payload)
  end

private

  def document_type
    'edition'
  end

  def document_id
    "/#{slug}"
  end

  def payload
    SearchPayloadPresenter.call(business_support_page)
  end
end
