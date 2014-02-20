RSpec::Matchers.define :have_element do |selector|
  match do |markup|
    @selector = selector
    @markup = markup
    expect(the_element).to be_present
    if @expected_classes
      expect(actual_classes).to match_array @expected_classes
    end
  end

  failure_message_for_should do |markup|
    if @expected_classes
      actual_classes = @element['class'].split(' ')
      "expected #{inspect_the_element} to have classes \"#{@expected_classes.sort.join(' ')}\" but it has classes \"#{actual_classes.sort.join(' ')}\""
    else
      "expected to find an element matching #{selector} in #{markup}"
    end
  end

  failure_message_for_should_not do |markup|
    "expected #{inspect_the_element} not to have classes \"#{@expected_classes.sort.join(' ')}\" in #{markup}"
  end

  chain :with_classes do |classes|
    @expected_classes = classes.split ' '
  end

  def the_element
    @element ||= begin
      doc = Nokogiri::XML @markup
      elements = doc.css @selector
      raise "could not find element matching\"#{@selector}\"" if elements.empty?
      raise "found multiple elements matching \"#{@selector}\"" unless elements.one?
      elements.first
    end
  end

  def inspect_the_element
    the_element.children = ""
    the_element
  end

  def actual_classes
    the_element['class'].split ' '
  end
end
