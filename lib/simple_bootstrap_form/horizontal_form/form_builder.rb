module SimpleBootstrapForm
  module HorizontalForm
    class FormBuilder < ::SimpleBootstrapForm::FormBuilder

      private

      def layout_css_class
        'form-horizontal'
      end

      def map_object_attribute_to_field_class(attr, options)
        prefix = field_class_prefix attr, options
        "SimpleBootstrapForm::HorizontalForm::Fields::#{prefix}Field".constantize
      end
    end
  end
end
