# InterpretDate

[![Build
status](https://travis-ci.org/sqm/interpret_date.svg?branch=master)](https://travis-ci.org/sqm/interpret_date)

Module to provide helper methods for interpreting American formatted date strings.

## Installation

Add this line to your application's Gemfile:

    gem 'interpret_date'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interpret_date

## Usage

To utilize `interpret_date`, mix in the `InterpretDate` module into a
class that needs to interpret American formatted dates into ruby Date
objects and pass the date string into the `interpret_date` or
`interpret_date_of_birth`.

Example (setting attributes for an example `ActiveRecord` model):

```ruby
class Parcel < ActiveRecord::Base
  include InterpretDate

  def shipping_date=(value)
    super(interpret_date(value))
  end

  def birthdate=(value)
    super(interpret_date_of_birth(value))
  end
end
```

## Contributing

1. Fork it ( https://github.com/sqm/interpret_date/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
