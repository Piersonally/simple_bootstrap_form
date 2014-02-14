# Bootstrap 3 Form Builder

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
imlementation.  I believe the continued non-appearance of Simple Form Bootstrap
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

## Support

#### Bootstrap Support

* Horizontal Form

#### Simple Form API Support

* Input types: boolean, datetime, email, password, text, textarea.  These are
  trivial to add.  Just take a look in fields/.
* Required fields.
* Placeholders, automatic and custom.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/my_gem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
