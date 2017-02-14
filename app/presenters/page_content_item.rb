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
      schema_name: 'generic',
      publishing_app: 'businesssupportfinder',
      rendering_app: 'businesssupportfinder',
      locale: 'en',
      public_updated_at: Time.now.iso8601,
      details: {},
      routes: [
        { type: 'prefix', path: base_path }
      ]
    }
  end

  def content_id
    data[:content_id]
  end

  def links
    {
      meets_user_needs: ["acf7d632-14a8-4201-a422-e8a4b3a7a847"]
    }
  end

private

  def data
    BusinessSupportPage::DATA
  end
end
