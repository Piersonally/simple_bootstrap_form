module SimpleBootstrapForm
  module HorizontalForm
    class FormBuilder < ActionView::Helpers::FormBuilder

      def initialize(object_name, object, template, options={})
        @field_factory = FieldFactory.new self, template
        process_options options
        super object_name, object, template, options_for_rails_form_builder
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

      def process_options(options)
        @options = options.dup
        @options.delete :layout
        @group_class = @options.delete :group_class
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
        options[:label_size] ||= field_label_size
        options[:input_size] ||= field_input_size
        options[:group_class] = @group_class if @group_class == false
        options
      end

      def field_label_size
        @options[:label_size] || 'col-sm-3'
      end

      def field_input_size
        @options[:input_size] || 'col-sm-6'
      end
    end
  end
end
