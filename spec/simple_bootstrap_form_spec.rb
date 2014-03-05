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

    describe "all forms" do
      subject do
        account_form
      end

      it "should have an ID" do
        should have_element %(form##{form_id}[action="/accounts"])
      end

      it "should have role 'form'" do
        should have_element "form##{form_id}[role=form]"
      end

      describe "f.input" do
        let(:field_id) { 'account_email' }

        describe "form-group" do
          it "should add a class describing the form group" do
            should have_element '.form-group.account_email_group'
          end

          context "when a :group_class option is provided" do
            subject {
              helper.bootstrap_form_for model do |f|
                f.input :email, group_class: "my_class"
              end
            }

            it "should add that value as a class to the group" do
              should have_element '.form-group.my_class'
            end
          end

          context "when :group_class is set to false on the input" do
            subject {
              helper.bootstrap_form_for model do |f|
                f.input :email, group_class: false
              end
            }

            it "should not add a field-specific class to that group" do
              should have_element('.form-group').with_only_classes('form-group')
            end
          end

          context "when :group_class is set to false on the form" do
            subject {
              helper.bootstrap_form_for model, group_class: false do |f|
                f.input :email
              end
            }

            it "should not add a field-specific class to the groups" do
              should have_element('.form-group').with_only_classes('form-group')
            end
          end
        end

        describe "label" do
          it { should have_element "form##{form_id} > .form-group " +
                                    "> label.control-label[for=#{field_id}]" }
        end

        describe "string field" do
          let(:field_id) { 'account_first_name' }

          it "should give the input an ID, and class form-control" do
            should have_element %(input##{field_id}.form-control[name="account[first_name]"])
          end

          it { should have_element("input##{field_id}").with_type('text') }
          it { should have_element("input##{field_id}").with_placeholder('First name') }
        end

        describe "integer field" do
          let(:field_id) { "account_id" }
          subject do
            helper.bootstrap_form_for model do |f|
              f.input :id
            end
          end
          it { should have_element("input##{field_id}").with_type('text') }
        end

        describe "email field (required)" do
          let(:field_id) { "account_email" }

          it { should have_element("input##{field_id}").with_type('email') }
          it { should have_element("input##{field_id}").with_placeholder('Email') }
          it { should have_element("input##{field_id}").with_attr_value(:required, 'required') }
        end

        describe "option :as =>" do
          let(:field_id) { "account_email" }
          subject do
            helper.bootstrap_form_for model do |f|
              f.input :email, as: :text
            end
          end
          it "should override the type" do
            should have_element("input##{field_id}").with_type('text')
          end
        end

        describe "password field" do
          let(:field_id) { "account_password" }

          it { should have_element("input##{field_id}").with_type('password') }
        end

        context "Using the Article form" do
          let(:model) { Article.new }
          subject { article_form }

          describe "text field (optional)" do
            let(:field_id) { 'article_body' }

            it { should have_element(:textarea).with_id(field_id) }
            it { should have_element(:textarea).with_id(field_id)
                                           .with_placeholder('Body') }
            it { should_not have_element(:textarea).with_id(field_id)
                                               .with_attr_value(:required, 'required') }
          end

          describe "datetime field" do
            let(:field_id) { "article_published_at" }

            it { should have_element("input##{field_id}").with_type('datetime') }
          end

          describe "boolean field" do
            let(:field_id) { 'article_visible' }

            it { should have_element("input##{field_id}").with_type('checkbox') }
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
    #  it { should have_element "form.form-inline" }
    #end

    describe "horizontal forms" do
      subject {
        helper.bootstrap_form_for(model, layout: 'horizontal') {}
      }

      describe "the form" do
        it { should have_element "form.form-horizontal" }
      end

      describe "f.input" do
        let(:field_id) { "account_email" }

        context "using size defaults" do
          subject {
            helper.bootstrap_form_for model, layout: 'horizontal' do |f|
              f.input(:email)
            end
          }

          it "should make the label col-sm-3 wide" do
            should have_element "label.col-sm-3[for=#{field_id}]"
          end

          it "should place the input inside a col-sm-6" do
            should have_element "form##{form_id} > .form-group > .col-sm-6 > input##{field_id}"
          end
        end

        context "when sizes are supplied to the form" do
          subject {
            helper.bootstrap_form_for model, layout: 'horizontal',
                                             label_size: 'col-md-3',
                                             input_size: 'col-md-6' do |f|
              f.input :email
            end
          }

          it "should use the form sizes for label and input" do
              should have_element "label.col-md-3[for=#{field_id}]"
              should have_element ".form-group > .col-md-6 > input##{field_id}"
          end

          context "when sizes are supplied to the input" do
            subject {
              helper.bootstrap_form_for model, layout: 'horizontal' do |f|
                f.input :email, label_size: 'col-xs-2', input_size: 'col-xs-4'
              end
            }

            it "input sizes should override the form sizes" do
              should have_element "label.col-xs-2[for=#{field_id}]"
              should have_element ".form-group > .col-xs-4 > input##{field_id}"
            end
          end
        end
      end

      describe "select" do
        let(:field_id) { "account_email" }
        before { model.email = "foo" }

        subject {
          helper.bootstrap_form_for model, layout: 'horizontal' do |f|
            f.input :email, collection: %w[foo bar]
          end
        }

        it "should generate a select tag with options" do
          should have_element '.form-group.account_email_group > div.col-sm-6 > select#account_email'
          should have_element('select#account_email > option[value="foo"][selected="selected"]').with_content("foo")
          should have_element('select#account_email > option[value="bar"]').with_content("bar")
        end
      end
    end
  end

  describe "getbootstrap.com examples" do
    describe "Basic example" do
      class Model1
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

      let!(:model) do
        Model1.new
      end

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

      subject {
        helper.bootstrap_form_for model, url: '/foo' do |f|
          f.input(:exampleInputEmail1) +
          f.input(:exampleInputPassword1) +
          f.input(:exampleInputFile, help: "Example block-level help text here.") +
          f.input(:check_me_out, as: :boolean)
        end
      }

      #it "should generate the correct output"
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
      class Model3
        include ActiveModel::Validations
        include ActiveModel::Conversion
        include ActiveModel::Naming

        def self.model_path
          "foo"
        end

        attr_accessor :inputEmail3
        attr_accessor :inputPassword3
        attr_accessor :remember_me
      end

      let!(:model) do
        Model3.new
      end

      # Original copy from getbootstrap.com
      #<form class="form-horizontal" role="form">
      #  <div class="form-group">
      #    <label for="inputEmail3" class="col-sm-2 control-label">Email</label>
      #    <div class="col-sm-10">
      #      <input type="email" class="form-control" id="inputEmail3" placeholder="Email">
      #    </div>
      #  </div>
      #  <div class="form-group">
      #    <label for="inputPassword3" class="col-sm-2 control-label">Password</label>
      #    <div class="col-sm-10">
      #      <input type="password" class="form-control" id="inputPassword3" placeholder="Password">
      #    </div>
      #  </div>
      #  <div class="form-group">
      #    <div class="col-sm-offset-2 col-sm-10">
      #      <div class="checkbox">
      #        <label>
      #          <input type="checkbox"> Remember me
      #        </label>
      #      </div>
      #    </div>
      #  </div>
      #  <div class="form-group">
      #    <div class="col-sm-offset-2 col-sm-10">
      #      <button type="submit" class="btn btn-default">Sign in</button>
      #    </div>
      #  </div>
      #</form>

      # The snippets below have been "Railsified" as follows:
      # <form>
      #   add accept-charset, action, id, method, model-specific class
      # <label>
      #   changed for= to model_field
      # <input>
      #   reorder input attributes to match Rails' order
      #   add name=

      let(:email_field_markup) {
        outdent <<-HTML
          <div class="form-group">
            <label class="col-sm-2 control-label" for="model3_inputEmail3">Email</label>
            <div class="col-sm-10">
              <input class="form-control" id="model3_inputEmail3" name="model3[inputEmail3]" placeholder="Email" type="email" />
            </div>
          </div>
        HTML
      }

      let(:password_field_markup) {
        outdent <<-HTML
          <div class="form-group">
            <label class="col-sm-2 control-label" for="model3_inputPassword3">Password</label>
            <div class="col-sm-10">
              <input class="form-control" id="model3_inputPassword3" name="model3[inputPassword3]" placeholder="Password" type="password" />
            </div>
          </div>
        HTML
      }

      subject {
        helper.bootstrap_form_for model,
                                  layout: :horizontal,
                                  label_size: 'col-sm-2',
                                  input_size: 'col-sm-10',
                                  group_class: false,
                                  url: '/foo' do |f|
          f.input(:inputEmail3, label: "Email", placeholder: "Email") +
          f.input(:inputPassword3, label: "Password", placeholder: "Password") +
          f.input(:remember_me, as: :boolean, label_size: 'col-sm-offset-2 col-sm-10')
        end
      }

      it "should generate the correct form tag" do
        expect(subject.to_s).to have_element('form')
                                .with_id('new_model3')
                                .with_only_classes('form-horizontal new_model3')
                                .with_attr_value(:action, '/foo')
      end

      it "should generate the correct email field" do
        markup = Nokogiri::XML(subject.to_s).css('.form-group').first
        expect(pretty_html markup.to_s).to eq email_field_markup
      end

      it "should generate the correct password field" do
        markup = Nokogiri::XML(subject.to_s).css('.form-group')[1]
        expect(pretty_html markup.to_s).to eq password_field_markup
      end
    end
  end
end
