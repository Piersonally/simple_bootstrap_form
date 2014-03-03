module SimpleBootstrapForm
  module HorizontalForm
    module Fields
      class BaseField

        class << self
          attr_accessor :type
        end

        def initialize(form_builder, template, name, options)
          @form_builder = form_builder
          @template = template
          @name = name
          process_options(options)
        end

        def to_s
        @template.content_tag :div, group_options do
            field_label +
            input_tag +
            errors_block
          end
        end

        private

        def process_options(options)
          @options = options.dup
          @label_size  = @options.delete :label_size
          @input_size  = @options.delete :input_size
          @label_text  = @options.delete :label
          @group_class = @options.delete :group_class
          unless @label_size && @input_size
            raise "label_size and input_size are required options"
          end
        end

        def group_options
          css_classes = CssClassList.new 'form-group', group_class
          css_classes << 'has-error' if has_error?
          { class: css_classes }
        end

        def group_class # a class for the form group to make it more testable
          case @group_class
          when false; nil
          when nil; "#{@form_builder.object_name.to_s.underscore}_#{@name}_group"
          else @group_class
          end
        end

        def field_label
          @form_builder.label @name, label_text, label_options
        end

        def label_text
          text = @label_text || @name.to_s.humanize.capitalize
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
          css_classes = CssClassList.new 'control-label'
          css_classes << @label_size
          { class: css_classes.to_s }
        end

        def input_tag
          @template.content_tag(:div, class: @input_size) do
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
          return @options[:required] if @options.has_key?(:required)
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
end
