require 'spec_helper'

describe "have_element RSpec matcher" do
  subject { '<input id="foo" class="bar baz" name="attr1" type="text" placeholder="Attr One"/>' }

  it { should     have_element("input") }
  it { should_not have_element("label") }

  it { should     have_element("input").with_id('foo') }
  it { should_not have_element("input").with_id('bad_id') }

  it { should     have_element("input").with_class('bar') }
  it { should_not have_element("input").with_class('bad_class') }

  it { should     have_element("input").with_attr_value(:name, 'attr1') }
  it { should     have_element("input").with_attr_value('name', 'attr1') }
  it { should_not have_element("input").with_attr_value(:name, 'bad_value') }
  it { should_not have_element("input").with_attr_value('name', 'bad_value') }

  it { should     have_element("input").with_type('text') }
  it { should_not have_element("input").with_type('radio') }

  it { should     have_element("input").with_placeholder('Attr One') }
  it { should_not have_element("input").with_placeholder('bad placeholder') }

  it { should     have_element("input").with_only_classes('bar baz') }
  it { should_not have_element("input").with_only_classes('bar') }

  it { should     have_element("input").with_id('foo')
                                       .with_class('bar')
                                       .with_only_classes('bar baz')
                                       .with_attr_value(:name, 'attr1')
                                       .with_type('text')
                                       .with_placeholder('Attr One')
  }

  describe "content testing" do
    subject { '<div id="foo">Some Content</div>' }

    it { should     have_element('div').with_content('Some Content') }
    it { should_not have_element('div').with_content('Some Content Extra') }
    it { should_not have_element('div').with_content('Bad Content') }

    it { should     have_element('div').with_id('foo').with_content('Some Content') }
    it { should_not have_element('div').with_id('foo').with_content('Bad Content') }
  end
end
