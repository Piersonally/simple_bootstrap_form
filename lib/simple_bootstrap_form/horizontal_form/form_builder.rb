module SimpleBootstrapForm
  module HorizontalForm
    class FormBuilder < ::SimpleBootstrapForm::FormBuilder

      def initialize(object_name, object, template, options, block=nil)
        @field_factory = FieldFactory.new self, template
        super object_name, object, template, builder_options(options), block
      end

      def input(name, options = {})
        @field_factory.for_attribute(name, options).to_s
      end

      def self.fully_qualified_class_name_for_field(field_class_name)
        # Better to do this manually than using introspection
        "SimpleBootstrapForm::HorizontalForm::Fields::#{field_class_name}"
      end

      private

      def layout_css_class
        'form-horizontal'
      end
    end
  end
end
