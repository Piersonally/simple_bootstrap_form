module SimpleBootstrapForm
  module HorizontalForm
    module Fields
      class SelectField < BaseField

        def input_tag
          @template.content_tag(:div, class: @input_size) do
            @form_builder.select @name, choices, options, html_options
          end
        end

        private

        def process_options(options)
          super
          @collection = @options.delete :collection
          unless @collection
            raise ":collection is a required option for select fields"
          end
        end

        def choices
          @template.options_for_select @collection, selected: model.send(@name)
        end

        def options
          {}
        end

        def html_options
          opts = {
            class: 'form-control'
          }
          opts.merge! required: 'required' if required?
          opts
        end
      end
    end
  end
end
