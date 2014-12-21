# Bootstrap 3 Form Builder

![CiecleCI Build Status](https://circleci.com/gh/Piersonally/simple_bootstrap_form.png?circle-token=1adabd4d96f92f6566f705581fb108ed59b31150)

* I'm a fan of [Boootstrap](http://getbootstrap.com/)
* I'm a fan of [Simple Form](https://github.com/plataformatec/simple_form)
* Bootstrap 3 was released in August 2013, but as of February 2014 Simple Form
  has yet to support it.
* If your forms are relatively simple, this gem can be used as a stop-gap
  measure until Simple Form supports Bootstrap 3.

People [have been working on Bootstrap 3 support for Simple
Form](https://github.com/plataformatec/simple_form/issues/857), for 7 months now
but as yet it has failed to see the light of day.

I think the reason for this may be that while Simple Form is configurable using
an initializer, Bootstrap 3 requires wrapping something in a new way, which
is going to require a new feature in the base Simple Form framework.

SimpleForm is a featurefull generic framework that will layout forms for
multiple different CSS frameworks (right now Bootstrap 2.3 and Zurb Foundation).
The challenge with this is that greater flexibility incurs greater complexity in
implementation.  I believe the continued non-appearance of Simple Form Bootstrap
3 support reflects the difficulty people have in working in this more complex
framework, and getting the results integrated and released.

This goal of this gem is to:

* Implement a subset of the Simple Form API
* Layout forms for Bootstrap 3 only
* Be easier to maintain

## Installation

Add this line to your application's Gemfile:

    gem 'simple_bootstrap_form'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_bootstrap_form

## Usage

Replace calls to:

    simple_form_for ...

with

    bootstrap_form_for ...

For example:

```haml
= bootstrap_form_for @article_form do |f|
  = f.input :title
  = f.input :published_at
  = f.input :visible
  = f.input :body, rows: 20
  = f.input :topic_names, label: 'Tags'
```

Generates (spaces added for clarity):

```html
<form accept-charset="UTF-8" action="/articles" class="form-horizontal"
      id="new_article" method="post" role="form">
  <div style="display:none"><input name="utf8" type="hidden" value="✓"><input
    name="authenticity_token" type="hidden"
    value="NYiknMBfTGqphSHozhG8NMCGQeWbRY6hzs2a0+gaxJw="></div>

  <div class="form-group article_title_group"><label
    class="control-label col-sm-3" for="article_title"><abbr
    title="required">*</abbr> Title</label>

    <div class="col-sm-6"><input class="form-control" id="article_title"
                                 name="article[title]" placeholder="Title"
                                 required="required" type="text"></div>
  </div>

  <div class="form-group article_published_at_group"><label
    class="control-label col-sm-3" for="article_published_at">Published
    at</label>
    <div class="col-sm-6">
      <div class="input-group"><input class="form-control"
                                      id="article_published_at"
                                      name="article[published_at]"
                                      placeholder="Published at"
                                      type="datetime">

        <div class="input-group-addon"><span
          class="glyphicon glyphicon-calendar"
          data-activate-datepicker="#article_published_at"></span></div>
      </div>
    </div>
  </div>

  <div class="form-group article_visible_group"><label
    class="control-label col-sm-3" for="article_visible">Visible</label>

    <div class="col-sm-6"><input name="article[visible]" type="hidden"
                                 value="0"><input id="article_visible"
                                                  name="article[visible]"
                                                  type="checkbox" value="1">
    </div>
  </div>

  <div class="form-group article_body_group"><label
    class="control-label col-sm-3" for="article_body">Body</label>

    <div class="col-sm-6"><textarea class="form-control" id="article_body"
                                    name="article[body]" placeholder="Body"
                                    rows="20"></textarea></div>
  </div>

  <div class="form-group article_topic_names_group"><label
    class="control-label col-sm-3" for="article_topic_names">Tags</label>

    <div class="col-sm-6"><input class="form-control" id="article_topic_names"
                                 label="Tags" name="article[topic_names]"
                                 placeholder="Topic names" type="text" value="">
    </div>
  </div>

  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-2">
      <input class="btn btn-primary" name="commit" type="submit" value="Save">
    </div>
  </div>
</form>
```

### Input Options

| Option         | Meaning                        | Default
|----------------|--------------------------------|------------
| `:as`          | Override column type. Use on of the types from the _Supported Field Types_ table below.
| `:label`       | Set custom label. | Humanized and titlized attribute name.
| `:placeholder` | Set custom placeholder. | Humanized and titlized attribute name.
| `:group_class` | For ease of testing in Capybara, a class is added to each `form-group` div, constructed from the object name and attribute name, e.g. `article_title_group`.  This option allows you to override that class name, or suppress using the value `false`. | (_model_)\_(_attribute_)\_group
| `:label_size`  | Bootstrap CSS class to use to size the label for this field.  By default this is set by the form.  This option is only needed if you need a label to be differently sized from the rest of the form's labels.
| `:input_size`  | Bootstrap CSS class to use to size the input for this field.  By default these are set by the form.  This option is only needed if you need an input to be differently sized from the rest of the form's inputs.
| `:required`    | Set this to `true`/`false` to override whether this field should be marked required. | If an attribute has a presence validator, it will be marked required.

## Support

#### Bootstrap Support

* Horizontal Form

#### Simple Form API Support

* Required fields.
* Placeholders, automatic and custom.

#### Supported Field Types

* These are straighforward to add.  Just take a look in fields/.

     Field Type      | Generated HTML Element                             | Database Column Type
     --------------- |:---------------------------------------------------|:--------------------
     `boolean`       | `input[type=checkbox]`                             | `boolean`
     `email`         | `input[type=email]`                                | `string` with `name =~ /email/`
     `password`      | `input[type=password]`                             | `string` with `name =~ /password/`
     `string`        | `input[type=text]`                                 | `string`
     `text`          | `textarea`                                         | `text`
     `datetime`      | `input[type=text]` setup for jquery.datetimepicker | `datetime`
     `select`        | `select`                                           | just provide a `collection:` option

## Contributing

1. Fork it ( http://github.com/<my-github-username>/my_gem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Releasing

1. Update `lib/simple_bootstrap_form/version.rb`
2. `git commit && git push`
3. `rake build`
4. `rake release`

## TODO

* Vertical Form
* Inline Form
* bootstrap\_fields\_for
* Suppress placeholder
