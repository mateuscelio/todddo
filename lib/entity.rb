# frozen_string_literal: true

class Entity
  def clone_with(**new_attrs)
    updated_attrs = to_h.merge(new_attrs)
    self.class.new(**updated_attrs)
  end

  def to_h
    instance_variables.reject { |variable| variable == :@validation_errors }
                      .each_with_object({}) do |instance_name, obj|
      obj[instance_name.to_s.gsub('@', '').to_sym] = instance_variable_get(instance_name)
    end
  end
end
