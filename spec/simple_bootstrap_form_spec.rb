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

    describe "the form" do
      it "should have and ID" do
        should have_selector %(form##{form_id}[action="/accounts"])
      end

      it "should be a horizontal form" do
        should have_selector "form##{form_id}.form-horizontal"
      end

      it "should have role 'form'" do
        should have_selector "form##{form_id}[role=form]"
      end
    end

    describe "f.input" do
      let(:field_id) { "account_email" }

      describe "form-group" do
        it "should add a class describing the form group" do
          should have_selector ".form-group.account_email_group"
        end
      end

      describe "label" do
        it { should have_selector "form##{form_id} > .form-group > label.control-label[for=#{field_id}]" }

        it "should make the label 3 columns wide" do
          should have_selector "label.col-sm-3[for=#{field_id}]"
        end
      end

      describe "string field" do
        let(:field_id) { 'account_first_name' }

        it "should give the input an ID, and class form-control" do
          should have_selector %(input##{field_id}.form-control[name="account[first_name]"])
        end

        it "should place the input inside a 6 column div" do
          should have_selector "form##{form_id} > .form-group > .col-sm-6 > input##{field_id}"
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
end
