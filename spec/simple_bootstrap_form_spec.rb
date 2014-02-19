require 'spec_helper'

describe SimpleBootstrapForm, type: :helper do

  def account_form
    helper.bootstrap_form_for model do |f|
      f.input(:email) +
      f.input(:first_name) +
      f.input(:password)
    end
  end

  def article_form
    helper.bootstrap_form_for model do |f|
      f.input(:title) +
      f.input(:published_at) +
      f.input(:visible) +
      f.input(:body)
    end
  end

  describe "#bootstrap_form_for" do
    let(:model) { Account.new }
    let(:form_id) { 'new_account' }

    subject do
      account_form
    end

    #it "should generate a form" do
    #  expect(subject).to eq(
    #    '<form accept-charset="UTF-8" action="/accounts" class="form-horizontal" id="new_account" method="post">' +
    #      '<div style="margin:0;padding:0;display:inline">'+
    #        '<input name="utf8" type="hidden" value="&#x2713;" />'+
    #      '</div>'+
    #      '<div class="form-group">'+
    #        '<label class="control-label col-sm-3" for="account_email"><abbr title="required">*</abbr> Email</label>'+
    #        '<div class="col-sm-6">'+
    #          '<input class="form-control" id="account_email" name="account[email]" placeholder="Email" required="required" type="email" />'+
    #        '</div>'+
    #      '</div>'+
    #    '</form>'
    #  )
    #end

    describe "all forms" do
      it "should have an ID" do
        should have_selector %(form##{form_id}[action="/accounts"])
      end

      it "should have role 'form'" do
        should have_selector "form##{form_id}[role=form]"
      end

      describe "f.input" do
        let(:field_id) { 'account_email' }

        describe "form-group" do
          it "should add a class describing the form group" do
            should have_selector '.form-group.account_email_group'
          end
        end

        describe "label" do
          it { should have_selector "form##{form_id} > .form-group " +
                                    "> label.control-label[for=#{field_id}]" }
        end

        describe "string field" do
          let(:field_id) { 'account_first_name' }

          it "should give the input an ID, and class form-control" do
            should have_selector %(input##{field_id}.form-control[name="account[first_name]"])
          end

          it { should have_input("##{field_id}").with_type('text') }
          it { should have_input("##{field_id}").with_placeholder('First name') }
        end

        describe "integer field" do
          let(:field_id) { "account_id" }
          subject do
            helper.bootstrap_form_for model do |f|
              f.input :id
            end
          end
          it { should have_input("##{field_id}").with_type('text') }
        end

        describe "email field (required)" do
          let(:field_id) { "account_email" }

          it { should have_input("##{field_id}").with_type('email') }
          it { should have_input("##{field_id}").with_placeholder('Email') }
          it { should have_input("##{field_id}").with_attr_value(:required, 'required') }
        end

        describe "option :as =>" do
          let(:field_id) { "account_email" }
          subject do
            helper.bootstrap_form_for model do |f|
              f.input :email, as: :text
            end
          end
          it "should override the type" do
            should have_input("##{field_id}").with_type('text')
          end
        end

        describe "password field" do
          let(:field_id) { "account_password" }

          it { should have_input("##{field_id}").with_type('password') }
        end

        context "Using the Article form" do
          let(:model) { Article.new }
          subject { article_form }

          describe "text field (optional)" do
            let(:field_id) { 'article_body' }

            it { should have_tag(:textarea).with_id(field_id) }
            it { should have_tag(:textarea).with_id(field_id)
                                           .with_placeholder('Body') }
            it { should_not have_tag(:textarea).with_id(field_id)
                                               .with_attr_value(:required, 'required') }
          end

          describe "datetime field" do
            let(:field_id) { "article_published_at" }

            it { should have_input("##{field_id}").with_type('datetime') }
          end

          describe "boolean field" do
            let(:field_id) { 'article_visible' }

            it { should have_input("##{field_id}").with_type('checkbox') }
          end
        end
      end
    end

    #describe "for vertical forms" do
    #end

    #describe "for inline forms" do
    #  subject {
    #    helper.bootstrap_form_for model, layout: 'inline' do |f|
    #      f.input(:email)
    #    end
    #  }
    #  it { should have_selector "form.form-inline" }
    #end

    describe "horizontal forms" do
      subject do
        helper.bootstrap_form_for(model, layout: 'horizontal') {}
      end

      describe "the form" do
        it { should have_selector "form.form-horizontal" }
      end

      describe "f.input" do
        subject do
          helper.bootstrap_form_for model, layout: 'horizontal' do |f|
            f.input(:email)
          end
        end
        let(:field_id) { "account_email" }

        describe "label" do
          it "should make the label 3 columns wide" do
            should have_selector "label.col-sm-3[for=#{field_id}]"
          end
        end

        it "should place the input inside a 6 column div" do
          should have_selector "form##{form_id} > .form-group > .col-sm-6 > input##{field_id}"
        end
      end
    end
  end

  describe "getbootstrap.com examples" do
    class Model
      include ActiveModel::Validations
      include ActiveModel::Conversion
      include ActiveModel::Naming

      def self.model_path
        "foo"
      end

      attr_accessor :exampleInputEmail1
      attr_accessor :exampleInputPassword1
      attr_accessor :exampleInputFile
      attr_accessor :check_me_out
    end

    def pretty_print(html)
      Nokogiri::XML(html, &:noblanks).to_xhtml
    end

    let!(:model) do
      Model.new
    end

    describe "Basic example" do
      let(:basic_example_output_from_getbootstrap_dot_com) {
        <<-BASIC_EXAMPLE
<form role="form">
  <div class="form-group">
    <label for="exampleInputEmail1">Email address</label>
    <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Enter email">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Password</label>
    <input type="password" class="form-control" id="exampleInputPassword1" placeholder="Password">
  </div>
  <div class="form-group">
    <label for="exampleInputFile">File input</label>
    <input type="file" id="exampleInputFile">
    <p class="help-block">Example block-level help text here.</p>
  </div>
  <div class="checkbox">
    <label>
      <input type="checkbox"> Check me out
    </label>
  </div>
  <button type="submit" class="btn btn-default">Submit</button>
</form>
        BASIC_EXAMPLE
      }

      subject do
        helper.bootstrap_form_for model, url: '/foo' do |f|
          f.input(:exampleInputEmail1) +
          f.input(:exampleInputPassword1) +
          f.input(:exampleInputFile, help: "Example block-level help text here.") +
          f.input(:check_me_out, as: :boolean)
        end
      end


      it "should generate the correct output"
    end

    describe "Inline form" do
      let(:inline_form_from_getbootstrap_dot_com) {
        <<-INLINE_FORM
<form class="form-inline" role="form">
  <div class="form-group">
    <label class="sr-only" for="exampleInputEmail2">Email address</label>
    <input type="email" class="form-control" id="exampleInputEmail2" placeholder="Enter email">
  </div>
  <div class="form-group">
    <label class="sr-only" for="exampleInputPassword2">Password</label>
    <input type="password" class="form-control" id="exampleInputPassword2" placeholder="Password">
  </div>
  <div class="checkbox">
    <label>
      <input type="checkbox"> Remember me
    </label>
  </div>
  <button type="submit" class="btn btn-default">Sign in</button>
</form>
        INLINE_FORM
      }
    end

    describe "Horizontal form" do
      let(:horizontal_form_output_from_getbootstrap_dot_com) {
        <<-HORIZONTAL_FORM
<form class="form-horizontal" role="form">
  <div class="form-group">
    <label for="inputEmail3" class="col-sm-2 control-label">Email</label>
    <div class="col-sm-10">
      <input type="email" class="form-control" id="inputEmail3" placeholder="Email">
    </div>
  </div>
  <div class="form-group">
    <label for="inputPassword3" class="col-sm-2 control-label">Password</label>
    <div class="col-sm-10">
      <input type="password" class="form-control" id="inputPassword3" placeholder="Password">
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-2 col-sm-10">
      <div class="checkbox">
        <label>
          <input type="checkbox"> Remember me
        </label>
      </div>
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-2 col-sm-10">
      <button type="submit" class="btn btn-default">Sign in</button>
    </div>
  </div>
</form>
        HORIZONTAL_FORM
      }

      subject do
        helper.bootstrap_form_for model,
                                  layout: :horizontal,
                                  label_size: 'sm-2',
                                  field_size: 'sm-10',
                                  url: '/foo' do |f|
          f.input(:exampleInputEmail1) +
          f.input(:exampleInputPassword1) +
          f.input(:exampleInputFile, help: "Example block-level help text here.") +
          f.input(:check_me_out, as: :boolean)
        end
      end

      it "should generate the correct output" do
        #expect(pretty_print subject).to eq horizontal_form_output_from_getbootstrap_dot_com
      end
    end
  end
end
