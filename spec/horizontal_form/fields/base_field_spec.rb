require 'spec_helper'

class MockTemplate
  attr_accessor :output_buffer
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormHelper
end

class Model1
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Naming
  
  attr_accessor :attr1
end

describe SimpleBootstrapForm::HorizontalForm::Fields::BaseField do
  let(:object) { Model1.new }
  let(:object_name) { "model1" }
  let(:template) { MockTemplate.new }
  let(:form_builder) { SimpleBootstrapForm::HorizontalForm::FormBuilder.new object_name, object, template }
  let(:attr_name) { "attr1" }
  let(:required_options) { { label_size: 'col-sm-3', input_size: "col-sm-6" } }
  let(:options) { required_options }

  subject { described_class.new(form_builder, template, attr_name, options).to_s }

  context "with no options" do
    let(:options) { {} }

    it "should raise an error" do
      expect {
       subject
      }.to raise_error
    end
  end

  describe "Full example demonstrating all options" do
    let(:options) {
      {
        label_size: 'col-xs-4',
        input_size: 'col-xs-6',
        group_class: 'custom-group-class',
        label: 'Custom Label',
        placeholder: 'Custom Placeholder'
      }
    }
    
    it "should generate the correct output" do
      expect(pretty_html subject).to eq outdent <<-HTML
        <div class="form-group custom-group-class">
          <label class="col-xs-4 control-label" for="model1_attr1">Custom Label</label>
          <div class="col-xs-6">
            <input class="form-control" id="model1_attr1" name="model1[attr1]" placeholder="Custom Placeholder" type="text" />
          </div>
        </div>
      HTML
    end
  end

  describe "Group class" do
    context "without a group class option" do
      let(:options) { required_options.merge label: "Custom Label" }

      it "should generate a group class using the object and field name" do
        expect(subject).to have_element('div.form-group')
                                .with_class('model1_attr1_group')
      end
    end

    context "given option group_class: false" do
      let(:options) { required_options.merge group_class: false }

      it "should only give the group class form-group" do
        expect(subject).to have_element('div.form-group').with_only_classes('form-group')
      end
    end

    context "given a custom group_class" do
      let(:options) { required_options.merge group_class: "CUSTOM_GROUP_CLASS" }

      it "should incorporate the custom group" do
        expect(subject).to have_element('div.form-group')
                                .with_class('CUSTOM_GROUP_CLASS')
      end
    end
  end
  
  describe "Form columns" do
    context "with label/input sizes" do
      let(:options) { { label_size: 'LABEL_CSS_CLASS', input_size: "INPUT_CSS_CLASS" } }

      it "should generate a horizontal field, defaulting to type text" do
        expect(subject).to have_element "label.LABEL_CSS_CLASS"
        expect(subject).to have_element "div.INPUT_CSS_CLASS > input"
      end
    end
  end

  describe "Label" do
    context "with no label option" do
      it "should generate the label by humanizing the object name" do
        expect(subject).to have_element('label').with_content('Attr1')
      end
    end

    context "for a required field" do
      before do
        allow(Model1).to receive(:validators_on).with('attr1').and_return(
          [ ActiveModel::Validations::PresenceValidator.new(attributes:'') ]
        )
      end

      it "should add an asterisk" do
        expect(subject).to have_element('label').with_content("* Attr1")
      end
    end

    context "Given a custom label" do
      let(:options) { required_options.merge label: "Custom Label" }

      it "should use the custom label" do
        expect(subject).to have_element('label').with_content('Custom Label')
      end

      context "for a required field" do
        before do
          allow(Model1).to receive(:validators_on).with('attr1').and_return(
            [ ActiveModel::Validations::PresenceValidator.new(attributes:'') ]
          )
        end

        it "should add an asterisk" do
          expect(subject).to have_element('label').with_content("* Custom Label")
        end
      end
    end
  end

  describe "Placeholder" do
    context "with no placeholder option" do
      it "should generate the placeholder by humanizing the object name" do
        expect(subject).to have_element('input').with_placeholder('Attr1')
      end
    end

    context "Given a placeholder option" do
      let(:options) { required_options.merge placeholder: "Custom Placeholder" }

      it "should use the custom label" do
        expect(subject).to have_element('input').with_placeholder('Custom Placeholder')
      end
    end
  end

  describe "Required Fields" do
    context "for a required field" do
      before do
        allow(Model1).to receive(:validators_on).with('attr1').and_return(
          [ ActiveModel::Validations::PresenceValidator.new(attributes:'') ]
        )
      end

      it "should add required=required to the input" do
        expect(subject).to have_element('input').with_attr_value(:required, 'required')
      end

      context "given option :required => false" do
        let(:options) { required_options.merge required: false }

        it "should not add required=required to the input" do
          expect(subject).not_to have_element('input').with_attr_value(:required, 'required')
        end
      end
    end

    context "for an optional field" do
      it "should not add required=required to the input" do
        expect(subject).not_to have_element('input').with_attr_value(:required, 'required')
      end

      context "given option :required => true" do
        let(:options) { required_options.merge required: true }

        it "should not add required=required to the input" do
          expect(subject).to have_element('input').with_attr_value(:required, 'required')
        end
      end
    end
  end
end
