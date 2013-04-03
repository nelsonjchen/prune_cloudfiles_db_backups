# PruneCfDbBackups

[![Code Climate](https://codeclimate.com/github/SmartReceipt/prune_cloudfiles_db_backups.png)](https://codeclimate.com/github/SmartReceipt/prune_cloudfiles_db_backups)

This gem helps prune useless database backups from Cloudfiles.

This does retains backup retention:

* Keep hourly files for two weeks.
* Keep weekly backups for 8 weeks on the Sundays.
* Keep monthy backups for 12 months on the Sundays.

## Usage

Check `prune_cloudfiles_db_backups -h` for the help banner.

## Installation

    $ gem install prune_cf_db_backups

## Usage

To see the usage prompt, run:

    prune_cloudfiles_db_backups --help

## Development

There is a `populate_dummy_container` ruby script inside the `test-util` folder. Run it with `-h` to see the help banner. This tool is to aid in copying the object names in a container to a test container for manual integration testing. It does not copy the content and only copies the object names.
