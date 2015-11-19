class PublishingApiNotifier
  def publish
    Services.publishing_api.put_content(rendered.content_id, rendered.payload)
    Services.publishing_api.publish(rendered.content_id, 'minor')
  end

private

  def rendered
    @rendered ||= PageContentItem.new
  end
end
