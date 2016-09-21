class SearchPayloadPresenter
  attr_reader :business_support_page
  delegate :slug,
           :title,
           :description,
           :indexable_content,
           :content_id,
           to: :business_support_page

  def initialize(business_support_page)
    @business_support_page = business_support_page
  end

  def self.call(business_support_page)
    new(business_support_page).call
  end

  def call
    {
      content_id: content_id,
      rendering_app: 'businesssupportfinder',
      publishing_app: 'businesssupportfinder',
      format: 'custom-application',
      title: title,
      description: description,
      indexable_content: indexable_content,
      link: "/#{slug}"
    }
  end
end
