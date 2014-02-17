module SimpleBootstrapForm
  module HorizontalForm
    module Fields
      class BooleanField < BaseField

        self.type = 'checkbox'

        def input_tag
          @template.content_tag(:div, class: 'col-sm-6') do
            @form_builder.check_box @name
          end
        end
      end
    end
  end
end
