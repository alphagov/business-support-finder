module ValidateArrayInclusion
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def validate_array_inclusion(field, allowed)
    if (send(field) - allowed).length > 0
      errors.add(field, :inclusion)
    end
  end

  module ClassMethods
    def validates_array_inclusion(field, allowed)
      validate { validate_array_inclusion(field, allowed) }
    end
  end
end