# Renders the page for the publishing-api.
class PageContentItem
  def base_path
    '/' + APP_SLUG
  end

  def payload
    {
      title: 'Finance and support for your business',
      format: 'placeholder_business_support_finder',
      publishing_app: 'businesssupportfinder',
      rendering_app: 'businesssupportfinder',
      update_type: 'minor',
      locale: 'en',
      public_updated_at: Time.now.iso8601,
      routes: [
        { type: 'exact', path: base_path }
      ]
    }
  end
end
