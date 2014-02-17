require 'spec_helper'

describe SimpleBootstrapForm::FieldFactory do
  let(:model) { double 'model' }
  let(:field_factory) { SimpleBootstrapForm::FieldFactory.new builder, nil }

  describe "#for_attribute" do
    let(:column) { double 'column' }
    let(:attr_name) { 'foo' }
    let(:options) { {} }

    def setup_stubs
      allow(builder).to receive(:object).and_return(model)
      allow(model).to receive(:column_for_attribute).with(attr_name).and_return(column)
      allow(column).to receive(:type).and_return(column_type)
    end

    subject { field_factory.for_attribute attr_name, options }

    context "when given a horizontal form builder" do
      let(:builder) { SimpleBootstrapForm::HorizontalForm::FormBuilder.new 'bogomodel', model, nil, {} }

      context "for a text field" do
        let(:column_type) { :string }
        before { setup_stubs }

        it { expect(subject).to be_a SimpleBootstrapForm::HorizontalForm::Fields::TextField }

        context "when given an :as option" do
          let(:options) { { as: :password } }

          it "should override the default field type with the supplied one" do
            expect(subject).to be_a SimpleBootstrapForm::HorizontalForm::Fields::PasswordField
          end
        end

        context "whose name includes 'email'" do
          let(:attr_name) { 'email' }

          it { expect(subject).to be_a SimpleBootstrapForm::HorizontalForm::Fields::EmailField }
        end

        context "whose name includes 'password'" do
          let(:attr_name) { 'password' }

          it { should be_a SimpleBootstrapForm::HorizontalForm::Fields::PasswordField }
        end
      end

      context "for a boolean field" do
        let(:column_type) { :boolean }
        before  { setup_stubs }

        it { expect(subject).to be_a SimpleBootstrapForm::HorizontalForm::Fields::BooleanField }
      end

      context "for a datetime field" do
        let(:column_type) { :datetime }
        before  { setup_stubs }

        it { expect(subject).to be_a SimpleBootstrapForm::HorizontalForm::Fields::DatetimeField }
      end
    end
  end
end
