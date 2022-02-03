# Multi-carrier Shipping Labels API

## Description
A small API Rails microservice that allow us to generate shipping labels.

## Requirements
* Rails 7.0.1
* Ruby 3.0.3
* PostgreSQL


## Getting started
To get started with the app, clone the repo and then install the needed gems:
```
$ cd /path/to/repos
$ git clone [shipping-labels-api](https://github.com/luisdgutierrez05/shipping-labels-api.git)
$ cd shipping-labels-api
$ bundle install
```

Next, setup the database:
```
$ cp config/database.yml.sample config/database.yml and add your Postgres settings.
$ rails db:setup
$ rails db:test:prepare
```

Finally, run the test suite to verify that everything is working correctly:
```
$ rspec
```

After running specs, open coverage/index.html in the browser of your choice:
```
open coverage/index.html
```

If the test suite passes, you'll be ready to run the app in a local server:
```
$ rails server or puma
```

# Code Overview

## Dependencies

## Design

Database:
API:

## Folders

## Endpoints

## Author

* **Luis D. Gutiérrez**
