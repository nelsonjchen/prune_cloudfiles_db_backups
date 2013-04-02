# PruneCfDbBackups

[![Code Climate](https://codeclimate.com/github/SmartReceipt/prune_cloudfiles_db_backups.png)](https://codeclimate.com/github/SmartReceipt/prune_cloudfiles_db_backups)

This gem helps prune useless database backups from Cloudfiles.

This does retains backup retention:

* Keep hourly files for two weeks.
* Keep weekly backups for 8 weeks.
* Keep monthy backups for 12 months.

## Serious Issues aka don't use this now.

What to do about timezones?

There should be tests.

## Installation

Add this line to your application's Gemfile:

    gem 'prune_cf_db_backups'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prune_cf_db_backups

## Usage

To see the usage prompt, run:

    prune_cloudfiles_db_backups --help


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
