# Renders the page for the publishing-api.
class PageContentItem
  def base_path
    '/' + APP_SLUG
  end

  def payload
    {
      base_path: base_path,
      title: data[:title],
      description: data[:description],
      document_type: 'business_support_finder',
      schema_name: 'placeholder_business_support_finder',
      publishing_app: 'businesssupportfinder',
      rendering_app: 'businesssupportfinder',
      locale: 'en',
      public_updated_at: Time.now.iso8601,
      details: {},
      routes: [
        { type: 'exact', path: base_path }
      ]
    }
  end

  def content_id
    data[:content_id]
  end

private

  def data
    BusinessSupportPage::DATA
  end
end
