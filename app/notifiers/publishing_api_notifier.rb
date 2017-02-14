class PublishingApiNotifier
  def publish
    Services.publishing_api.put_content(rendered.content_id, rendered.payload)
    Services.publishing_api.publish(rendered.content_id, 'minor')
    Services.publishing_api.patch_links(rendered.content_id, links: rendered.links)
  end

private

  def rendered
    @rendered ||= PageContentItem.new
  end
end
