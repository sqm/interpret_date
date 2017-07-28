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

### Instance Methods

To utilize `interpret_date`, mix in the `InterpretDate` module into a
class that needs to interpret American formatted dates into ruby Date
objects and pass the date string into the `interpret_date` or
`interpret_dob_date`.

Example (setting attributes for an example `ActiveRecord` model):

```ruby
class Parcel < ActiveRecord::Base
  include InterpretDate

  def shipping_date=(value)
    super(interpret_date(value))
  end

  def birthdate=(value)
    super(interpret_dob_date(value))
  end
end
```

### ActiveRecord Date Type

You can also utilize `InterpretDate` with the ActiveRecord Attribute
API to automatically cast dates with their interpreted values.

```ruby
class Parcel < ActiveRecord::Base
  attribute :shipping_date, InterpretDate::DateType.new
end
```

If you plan on using the Date Type extensively you can register it in
an initializer.

```ruby
# config/initializers/types.rb
ActiveRecord::Type.register(:interpreted_date, InterpretDate::DateType)
```

```ruby
class Parcel < ActiveRecord::Base
  attribute :shipping_date, :interpreted_date
end
```

## Contributing

1. Fork it ( https://github.com/sqm/interpret_date/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
