module SimpleBootstrapForm
  module HorizontalForm
    module Fields
      class DatetimeField < BaseField

        self.type = 'datetime'

        def input_tag
          @template.content_tag(:div, class: 'col-sm-6') do
            @template.content_tag :div, class: 'input-group' do
              @form_builder.text_field(@name, input_options) +
              calendar_icon
            end
          end
        end

        private

        def calendar_icon
          @template.content_tag(:div, class: 'input-group-addon') do
            @template.content_tag(:span, '',
              class: 'glyphicon glyphicon-calendar',
              data: { 'activate-datepicker' => "##{tag_id}" }
            )
          end
        end

        def input_options
          super
          @options.merge! value: value_suitable_for_use_by_jquery_datetimepicker
          @options
        end

        def value_suitable_for_use_by_jquery_datetimepicker
          @form_builder.object.send(@name).try(:strftime, '%Y/%m/%d %H:%M')
        end

        # Adapted from module ActionView::Helpers::Tags::Base
        def tag_id
          "#{sanitized_object_name}_#{sanitized_method_name}"
        end

        # Adapted from module ActionView::Helpers::Tags::Base
        def sanitized_object_name
          @form_builder.object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
        end

        # Adapted from module ActionView::Helpers::Tags::Base
        def sanitized_method_name
          @name.to_s.sub(/\?$/,"")
        end
      end
    end
  end
end
