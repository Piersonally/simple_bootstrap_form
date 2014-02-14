module SimpleBootstrapForm
  module Fields
    class TextareaField < BaseField

      def input_tag
        @template.content_tag(:div, class: 'col-sm-6') do
          @form_builder.text_area @name, input_options
        end
      end
    end
  end
end
