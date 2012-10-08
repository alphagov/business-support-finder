module AddRemoveHelper
  def link_to_add_remove(action, model, options = {})
    key_name = model.class.name.underscore
      id_sufix = options[:id_sufix]
      item_class = options.delete(:item_class)
      model_slug = "#{key_name}-#{model.slug}"
      model_slug = "#{model_slug}-#{id_sufix}" unless id_sufix.nil?
      tag_options = {"data-slug"=> model.slug}
      tag_options["class"] = item_class unless item_class.nil?
      content_tag :li, tag_options do
        html = content_tag(:span, model.name, :class => "#{key_name}-name", :id => "#{model_slug}") + "\n"
      html << create_add_remove_link(action, model, options)
    end
  end

  def link_to_add(model, options = {})
    link_to_add_remove(:add, model, options)
  end

  def selected_link(model, options = {})
    options[:item_class] = "selected"
    link_to_add_remove(:remove, model, options)
  end

  def basket_link(model, options = {})
    options[:id_sufix] = "selected"
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
    id_sufix = options[:id_sufix]
    model_slug = "#{key_name}-#{model.slug}"
    model_slug = "#{model_slug}-#{id_sufix}" unless id_sufix.nil?
    new_params = params.select {|k, v| %w(controller sectors).include? k.to_s }
    new_params[key_name.pluralize] = items.map(&:slug).sort.uniq.join("_")
    link_to(action.capitalize, url_for(new_params.merge(:action => key_name.pluralize)), :class => action, "aria-labelledby" => "#{model_slug}")
  end
end
