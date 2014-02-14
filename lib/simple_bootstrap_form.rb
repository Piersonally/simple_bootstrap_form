require 'simple_bootstrap_form'
require 'simple_bootstrap_form/css_class_list'
require 'simple_bootstrap_form/action_view_extensions'
require 'simple_bootstrap_form/form_builder'
require 'simple_bootstrap_form/fields/base_field'
require 'simple_bootstrap_form/fields/boolean_field'
require 'simple_bootstrap_form/fields/datetime_field'
require 'simple_bootstrap_form/fields/email_field'
require 'simple_bootstrap_form/fields/password_field'
require 'simple_bootstrap_form/fields/text_field'
require 'simple_bootstrap_form/fields/textarea_field'

ActionView::Base.send :include, SimpleBootstrapForm::ActionViewExtensions
