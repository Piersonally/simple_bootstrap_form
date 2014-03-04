require 'nokogiri'

RSpec::Matchers.define :have_element do |selector|
  match do |markup|
    @selector = selector
    @markup = markup
    element_is_present && classes_match && content_matches
  end

  failure_message do |markup|
    if the_element.nil?
      "expected to find an element matching #{actual_selector} in #{markup}"
    else
      error_messages = [
        classes_match_error_message,
        content_matches_error_message(:should)
      ].reject(&:blank?)
      "expected #{inspect_the_element} to " + error_messages.join(' and ')
    end
  end

  failure_message_when_negated do |markup|
    if checking_classes? || checking_content?
      if the_element.nil?
        # If we have post tag-retrieval checks, it is an error not to find the tag
        "expected to find an element matching #{actual_selector} in #{markup}"
      else
        error_messages = [
          classes_match_error_message,
          content_matches_error_message(:should_not)
        ].reject(&:blank?)
        "expected #{inspect_the_element} not to " + error_messages.join(' and ')
      end
    else
      "expected not to find an element matching #{actual_selector} in #{markup}"
    end
  end

  def element_is_present
    the_element.is_a? Nokogiri::XML::Element
  end

  ########## Chain assertions used to build the selector

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
  
  def checking_classes?
    !!@expected_classes
  end
  
  def actual_classes
    @actual_classes ||= the_element['class'].split ' '
  end
  
  def classes_match
    return true unless @expected_classes
    actual_classes.sort == @expected_classes.sort
  end

  def classes_match_error_message
    return nil unless checking_classes?
    "have classes \"%s\" but it has classes \"%s\"" % [
      @expected_classes.sort.join(' '),
      @actual_classes.sort.join(' ')
    ]
  end

  chain :with_content do |content|
    @expected_content = content
  end

  def checking_content?
    !!@expected_content
  end
  
  def actual_content
    @actual_content ||= the_element.text
  end

  def content_matches
    return true unless @expected_content
    actual_content == @expected_content
  end

  def content_matches_error_message(comparison=:should)
    return nil unless checking_content?
    return nil if comparison == :should && content_matches
    return nil if comparison == :should_not && !content_matches
    "have content \"%s\" but it has content \"%s\"" % [
      @expected_content, @actual_content
    ]
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
