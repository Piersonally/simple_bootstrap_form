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

  describe "#with_only_classes" do
    it { should     have_element("input").with_only_classes('bar baz') }
    it { should_not have_element("input").with_only_classes('bar') }

    it "should have an appropriate error message for should" do
      matcher = have_element("input").with_only_classes('bar')
      expect(matcher.matches? subject).to eq false
      expect(matcher.failure_message_for_should).to eq(
        %Q{expected #{subject} to have classes "bar" but it has classes "bar baz"}
      )
    end

    it "should have an appropriate error message for should not" do
      matcher = have_element("input").with_only_classes('bar baz')
      expect(matcher.matches? subject).to eq true
      expect(matcher.failure_message_for_should_not).to eq(
        %Q{expected #{subject} not to have classes "bar baz" but it has classes "bar baz"}
      )
    end
  end

  describe "combo" do
    it { should     have_element("input").with_id('foo')
                                         .with_class('bar')
                                         .with_only_classes('bar baz')
                                         .with_attr_value(:name, 'attr1')
                                         .with_type('text')
                                         .with_placeholder('Attr One')
    }

    it "should have an appropriate error message for should" do
      matcher = have_element("input").with_id('foo')
                                     .with_class('bar')
                                     .with_only_classes('bad class list')
                                     .with_attr_value(:name, 'attr1')
                                     .with_type('text')
                                     .with_placeholder('Attr One')

      expect(matcher.matches? subject).to eq false
      expect(matcher.failure_message_for_should).to eq(
        %Q{expected #{subject} to have classes "bad class list" but it has classes "bar baz"}
      )
    end

    it { should_not have_element("input").with_id('foo')
                                         .with_class('bar')
                                         .with_only_classes('bar baz')
                                         .with_attr_value(:name, 'attr1')
                                         .with_type('bad_type')
                                         .with_placeholder('Attr One')
    }
  end

  describe "content testing" do
    subject { '<div id="foo" class="c1 c2">Some Content</div>' }
    let(:inspected_subject) { '<div id="foo" class="c1 c2"/>' }

    it { should     have_element('div').with_content('Some Content') }
    it { should_not have_element('div').with_content('Some Content with extra') }
    it { should_not have_element('div').with_content('Bad Content') }

    it { should     have_element('div').with_id('foo').with_content('Some Content') }
    it { should_not have_element('div').with_id('foo').with_content('Bad Content') }

    describe "error messages" do
      it "should have an appropriate error message for should" do
        matcher = have_element("div").with_id('foo').with_content('Bad Content')
        expect(matcher.matches? subject).to eq false
        expect(matcher.failure_message_for_should).to eq(
          %Q{expected #{inspected_subject} to } +
          %Q{have content "Bad Content" but it has content "Some Content"}
        )
      end

      it "should have an appropriate error message for should not" do
        matcher = have_element("div").with_id('foo').with_content('Some Content')
        expect(matcher.matches? subject).to eq true
        expect(matcher.failure_message_for_should_not).to eq(
          %Q{expected #{inspected_subject} not to } +
          %Q{have content "Some Content" but it has content "Some Content"}
        )
      end

      it "should generate correct combo error messages" do
        matcher = have_element("div").with_id('foo')
                                     .with_only_classes('bar')
                                     .with_content('Bad Content')
        expect(matcher.matches? subject).to eq false
        expect(matcher.failure_message_for_should).to eq(
          %Q{expected #{inspected_subject} to } +
          %Q{have classes "bar" but it has classes "c1 c2"} +
          %Q{ and have content "Bad Content" but it has content "Some Content"}
        )
      end
    end
  end
end
