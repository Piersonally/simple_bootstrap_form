module SimpleBootstrapForm
  class FieldFactory

    def initialize(builder, template)
      @builder  = builder
      @template = template
    end

    def for_attribute(attr, options)
      field_class(attr, options).new(@builder, @template, attr, options)
    end

    private

    def field_class(attr, options)
      field_class_name(attr, options).constantize
    end

    def field_class_name(attr, options)
      type_prefix = field_class_type_prefix attr, options
      class_name = "#{type_prefix}Field"
      @builder.class.fully_qualified_class_name_for_field class_name
    end

    # Return first half of a field class name, based on the type of the
    # field: 'Text', 'Email', 'Password', 'Textarea', 'Boolean', etc.
    # Appending 'Field' to this gets you a real class, e.g. TextField
    def field_class_type_prefix(attr, options)
      if options[:as]
        options[:as].to_s.capitalize
      elsif options.has_key? :collection
        'Select'
      else
        derive_field_class_prefix attr
      end
    end

    def derive_field_class_prefix(attr)
      case attr_column_type(attr)
      when :boolean; 'Boolean'
      when :datetime; 'Datetime'
      when :string; string_field_class_prefix_based_on_column_name(attr)
      when :text  ; 'Textarea'
      else 'Text'
      end
    end

    def attr_column_type(attr)
      ActiveSupport::Deprecation.silence do
        @builder.object.try(:column_for_attribute, attr).try(:type) || :string
      end
    end

    def string_field_class_prefix_based_on_column_name(attr)
      case
      when attr.to_s =~ /email/i    ; 'Email'
      when attr.to_s =~ /password/i ; 'Password'
      else 'Text'
      end
    end
  end
end
