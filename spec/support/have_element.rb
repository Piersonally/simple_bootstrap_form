require 'nokogiri'

RSpec::Matchers.define :have_element do |selector|
  match_for_should do |markup|
    @selector = selector
    @markup = markup
    element_is_present && classes_match
  end

  match_for_should_not do |markup|
    @selector = selector
    @markup = markup
    !element_is_present || !classes_match
  end

  failure_message_for_should do |markup|
    if the_element.nil?
      "expected to find an element matching #{selector} in #{markup}"
    elsif @expected_classes
      actual_classes = @element['class'].split(' ')
      "expected #{inspect_the_element} to have classes \"#{@expected_classes.sort.join(' ')}\" but it has classes \"#{actual_classes.sort.join(' ')}\""
    else
    end
  end

  failure_message_for_should_not do |markup|
    "expected #{inspect_the_element} not to have classes \"#{@expected_classes.sort.join(' ')}\" in #{markup}"
  end

  def element_is_present
    the_element.is_a? Nokogiri::XML::Element
  end

  def check_element(element)
    if @expected_classes
    else
      true
    end
  end

  ########## Chain assertions that will affect the selector

  chain :with_id do |id|
    @id = id
  end

  chain :with_class do |css_class|
    @class = css_class
  end

  def attrs
    @attrs ||= {}
  end

  chain :with_attr_value do |attr, value|
    attrs[attr] = value
  end

  chain :with_type do |type|
    attrs['type'] = type
  end

  chain :with_placeholder do |placeholder|
    attrs['placeholder'] = placeholder
  end

  def actual_selector
    @actual_selector ||= begin
      s = @selector.to_s.dup
      s << "##{@id}" if @id
      s << ".#{@class}" if @class
      attrs.each do |attr, value|
        s << "[#{attr}=\"#{value}\"]"
      end
      s
    end
  end

  ########## Chain assertions that are run once the tag has been recovered

  chain :with_only_classes do |classes|
    @expected_classes = classes.split ' '
  end
  
  def actual_classes
    the_element['class'].split ' '
  end
  
  def classes_match
    return true unless @expected_classes
    actual_classes.sort == @expected_classes.sort
  end
  
  ########## Utility methods
  
  def the_element
    @element ||= begin
      doc = Nokogiri::XML @markup
      elements = doc.css actual_selector
      raise "found multiple elements matching \"#{actual_selector}\"" if elements.count > 1
      elements.first
    end
  end

  def inspect_the_element
    the_element.children = ""
    the_element
  end
end
