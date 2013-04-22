# PruneCfDbBackups

[![Build Status](https://travis-ci.org/SmartReceipt/prune_cloudfiles_db_backups.png?branch=master)](https://travis-ci.org/SmartReceipt/prune_cloudfiles_db_backups)
[![Coverage Status](https://coveralls.io/repos/SmartReceipt/prune_cloudfiles_db_backups/badge.png?branch=master)](https://coveralls.io/r/SmartReceipt/prune_cloudfiles_db_backups)
[![Code Climate](https://codeclimate.com/github/SmartReceipt/prune_cloudfiles_db_backups.png)](https://codeclimate.com/github/SmartReceipt/prune_cloudfiles_db_backups)
[![Dependency Status](https://gemnasium.com/SmartReceipt/prune_cloudfiles_db_backups.png)](https://gemnasium.com/SmartReceipt/prune_cloudfiles_db_backups)

This gem helps prune useless database backups from Cloudfiles.

The current backup retention defaults enforced by this tool are:

* Keep hourly files for two weeks.
* Keep weekly backups for 8 weeks on the Sundays.
* Keep monthy backups for 12 months on the Sundays.

## Usage

To see the usage prompt, run:

    prune_cloudfiles_db_backups --help

The first deletion run, if not run for a year, will take a very long time.

## Installation

    $ gem install prune_cloudfiles_db_backups

Or stick it in bundler, a chef recipe, or whatever!

## Usage

To see the usage prompt, run:

    prune_cloudfiles_db_backups --help

## Development Tools

There is a `populate_dummy_container` ruby script inside the `test-util` folder. Also run it with `-h` to see the help banner. This tool is to aid in copying the object names in a container to a test container for manual integration testing. It does not copy the content and only copies the object names.
