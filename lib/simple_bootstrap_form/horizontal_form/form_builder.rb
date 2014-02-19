module SimpleBootstrapForm
  module HorizontalForm
    class FormBuilder < ActionView::Helpers::FormBuilder

      def initialize(object_name, object, template, options={}, block=nil)
        @field_factory = FieldFactory.new self, template
        process_options options
        super object_name, object, template, options_for_rails_form_builder, block
      end

      def input(name, supplied_options = {})
        options = field_options(supplied_options)
        @field_factory.for_attribute(name, options).to_s
      end

      def self.fully_qualified_class_name_for_field(field_class_name)
        # Better to do this manually than using introspection
        "SimpleBootstrapForm::HorizontalForm::Fields::#{field_class_name}"
      end

      private

      def process_options(options )
        @options = options.dup
        @options.delete :layout
      end

      def options_for_rails_form_builder
        @options[:html] ||= {}
        @options[:html][:role] ||= 'form'
        @options[:html][:class] = form_css_classes
        @options
      end

      def form_css_classes
        css_classes = CssClassList.new options[:html][:class]
        css_classes << 'form-horizontal'
        css_classes
      end

      def field_options(supplied_options)
        options = supplied_options.dup
        options[:label_size] = field_label_size
        options[:input_size] = input_size
        options
      end
    end
  end
end
