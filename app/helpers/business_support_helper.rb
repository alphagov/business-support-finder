module BusinessSupportHelper

  def formatted_facet_values(values)
    values.join(" ") if values
  end

end
