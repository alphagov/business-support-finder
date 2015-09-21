class PublishingApiNotifier
  def publish
    Services.publishing_api.put_content_item(rendered.base_path, rendered.payload)
  end

private

  def rendered
    @rendered ||= PageContentItem.new
  end
end
