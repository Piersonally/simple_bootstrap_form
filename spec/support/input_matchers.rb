RSpec::Matchers.define :have_input do |input_id|
  match_for_should do |markup|
    expect(markup).to have_selector selector(input_id)
  end

  match_for_should_not do |markup|
    !(expect(markup).not_to have_selector selector(input_id))
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

  def attrs
    @attrs ||= {}
  end

  def selector(input_id)
    s = "input#{input_id}"
    attrs.each do |attr, value|
      s << %([#{attr}="#{value}"])
    end
    s
  end
end

RSpec::Matchers.define :have_tag do |tag|
  match_for_should do |markup|
    expect(markup).to have_selector selector(tag)
  end

  match_for_should_not do |markup|
    !(expect(markup).not_to have_selector selector(tag))
  end

  chain :with_id do |id|
    @id = id
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

  def attrs
    @attrs ||= {}
  end

  def selector(tag)
    s = tag.to_s
    s << "##{@id}" if @id
    attrs.each do |attr, value|
      s << "[#{attr}=#{value}]"
    end
    s
  end
end
