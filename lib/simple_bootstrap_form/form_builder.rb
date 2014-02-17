module SimpleBootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder

    def initialize(object_name, object, template, options, block=nil)
      super object_name, object, template, builder_options(options), block
    end

    # Context inherited from ActionView::Helpers::FormBuilder:
    #
    #   @template
    #   object

    private

    def builder_options(options)
      @options = options.extract! :layout
      options[:html] ||= {}
      options[:html][:class] = CssClassList.new options[:html][:class]
      options[:html][:role] ||= 'form'
      options[:html][:class] << layout_css_class
      options
    end

    def layout_css_class
      raise "You must inplement layout_css_class in your
             SimpleBootstrapForm::FormBuilder subclass"
    end
  end
end
