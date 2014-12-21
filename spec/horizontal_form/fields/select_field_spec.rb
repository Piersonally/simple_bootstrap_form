require 'spec_helper'

class MockTemplate
  attr_accessor :output_buffer
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
end

class Model1
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Naming

  attr_accessor :attr1
end

describe SimpleBootstrapForm::HorizontalForm::Fields::SelectField do

  let(:object) { Model1.new }
  let(:object_name) { "model1" }
  let(:template) { MockTemplate.new }
  let(:form_builder) { SimpleBootstrapForm::HorizontalForm::FormBuilder.new object_name, object, template }
  let(:attr_name) { "attr1" }
  let(:required_options) { { label_size: 'col-sm-3', input_size: "col-sm-6" } }
  let(:options) { required_options }

  subject { described_class.new(form_builder, template, attr_name, options).to_s }

  context "without a collection: option" do
    it { expect { subject.to_s }.to raise_error }
  end

  context "with a simple array collection" do
    let(:options) { required_options.merge collection: [1,3,5] }
    before { object.attr1 = 5 }

    it "should generate a select tag" do
      expect(pretty_html subject.to_s).to eq outdent <<-HTML
        <div class="form-group model1_attr1_group">
          <label class="col-sm-3 control-label" for="model1_attr1">Attr1</label>
          <div class="col-sm-6">
            <select class="form-control" name="model1[attr1]" id="model1_attr1">
              <option value="1">1</option>
              <option value="3">3</option>
              <option selected="selected" value="5">5</option>
            </select>
          </div>
        </div>
      HTML
    end

    context "for a required attribute" do
      before do
        allow(Model1).to receive(:validators_on).with('attr1').and_return(
          [ ActiveModel::Validations::PresenceValidator.new(attributes:'') ]
        )
      end

      it { should have_element('select').with_attr_value(:required, 'required') }
    end
  end
end
