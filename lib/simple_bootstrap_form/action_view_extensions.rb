module SimpleBootstrapForm
  module ActionViewExtensions

    def bootstrap_form_for(record, options={}, &block)
      options[:builder] ||= SimpleBootstrapForm::FormBuilder
      options[:html] ||= {}
      options[:html][:class] = CssClassList.new options[:html][:class]
      options[:html][:class] << 'form-horizontal'
      options[:html][:role] ||= 'form'
      prevent_action_view_putting_a_div_around_all_fields_with_errors do
        form_for record, options, &block
      end
    end

    private

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
