# SqlEnum

Enables usage of native sql enums with ActiveRecord

## NOTE

Version 2.0 of this gem requires Rails 7.1+ and Ruby 3.2+.

For Rails 7.0 and 7.1, use version 1.0. For Rails versions below 7, use version 0.4.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sql_enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sql_enum

## Usage

### Migrations

Use a part of table definition:
```ruby
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.enum :status, limit: [:active, :pending, :inactive], default: :active

      t.timestamps
    end
  end
end
```

Or add an enum column:
```ruby
add_column :users, :status, :enum, limit: [:active, :pending, :inactive], default: :active
```

### ActiveRecord

```ruby
class User < ActiveRecord::Base
  sql_enum :status
end
```

## Development

### Testing

Run `docker compose run --rm rspec` to run the specs in a docker container alongside Mysql.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/1debit/sql_enum. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

Inspiration from [native_enum](https://github.com/iangreenleaf/native_enum)

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SqlEnum project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/1debit/sql_enum/blob/main/CODE_OF_CONDUCT.md).
