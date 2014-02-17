module SimpleBootstrapForm
  module ActionViewExtensions

    def bootstrap_form_for(record, options={}, &block)
      options[:builder] ||= form_builder_class options
      prevent_action_view_putting_a_div_around_all_fields_with_errors do
        form_for record, options, &block
      end
    end

    private

    def form_builder_class(options)
      SimpleBootstrapForm::HorizontalForm::FormBuilder
    end

    def prevent_action_view_putting_a_div_around_all_fields_with_errors(&block)
      orig_field_error_proc = ::ActionView::Base.field_error_proc
      begin
        ::ActionView::Base.field_error_proc = SimpleBootstrapForm.method :noop_field_error_proc
        yield
      ensure
        ::ActionView::Base.field_error_proc = orig_field_error_proc
      end
    end
  end

  def self.noop_field_error_proc(html_tag, instance)
    html_tag
  end
end
