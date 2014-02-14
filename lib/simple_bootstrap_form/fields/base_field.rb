module SimpleBootstrapForm
  module Fields
    class BaseField

      class << self
        attr_accessor :type
      end

      def initialize(form_builder, template, name, options)
        @form_builder = form_builder
        @template = template
        @name = name
        @options = options.dup
      end

      def to_s
        @template.content_tag :div, group_options do
          field_label +
          input_tag +
          errors_block
        end
      end

      private

      def group_options
        css_classes = CssClassList.new 'form-group', group_name
        css_classes << 'has-error' if has_error?
        { class: css_classes }
      end

      def group_name # added as a class on form group to make it more testable
        "#{@form_builder.object_name.to_s.underscore}_#{@name}_group"
      end

      def field_label
        @form_builder.label @name, label_text, label_options
      end

      def label_text
        text = @options[:label] || @name.to_s.humanize.capitalize
        required_asterisk + text
      end

      def required_asterisk
        if required?
          @template.content_tag(:abbr, '*', title: 'required') + ' '
        else
          ''
        end.html_safe
      end

      def label_options
        css_classes = CssClassList.new 'control-label col-sm-3'
        { class: css_classes }
      end

      def input_tag
        @template.content_tag(:div, class: 'col-sm-6') do
          @form_builder.text_field @name, input_options
        end
      end

      def input_options
        @options.merge! class: 'form-control',
                        placeholder: placeholder,
                        type: self.class.type
        @options.merge! required: 'required' if required?
        @options
      end

      def placeholder
        @options[:placeholder] || @name.to_s.humanize
      end

      def errors_block
        return '' unless errors.any?
        @template.content_tag :span, errors.join(', '),
                                     class: 'help-block col-sm-3'
      end

      def model
        @form_builder.object
      end

      def errors
        return [] unless model
        @cached_errors ||= model.errors[@name.to_sym]
      end

      def required?
        return false unless model
        model.class.validators_on(@name).any? do |validator|
          validator.kind_of? ActiveModel::Validations::PresenceValidator
        end
      end

      def has_error?
        errors.any?
      end
    end
  end
end
