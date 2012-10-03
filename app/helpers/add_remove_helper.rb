module AddRemoveHelper
  def link_to_add_remove(action, model, options = {})
    key_name = model.class.name.underscore
    content_tag :li, "data-slug" => model.slug do
      html = content_tag(:span, model.name, :class => "#{key_name}-name", :id => "#{key_name}-#{model.slug}") + "\n"
      html << create_add_remove_link(action, model, options)
    end
  end

  def link_to_add(model, options = {})
    link_to_add_remove(:add, model, options)
  end

  def link_to_remove(model, options = {})
    link_to_add_remove(:remove, model, options)
  end

  def create_add_remove_link(action, model, options = {})
    items = options[:existing_items] || []
    if action == :add
      items += [model]
    else
      items -= [model]
    end
    key_name = model.class.name.underscore
    new_params = params.select {|k, v| %w(controller sectors).include? k.to_s }
    new_params[key_name.pluralize] = items.map(&:slug).sort.uniq.join("_")
    link_to(action.capitalize, url_for(new_params.merge(:action => key_name.pluralize)), :class => action, "aria-labelledby" => "#{key_name}-#{model.slug}")
  end
end
