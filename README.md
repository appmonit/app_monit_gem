[![Build Status](https://travis-ci.org/appmonit/app_monit_gem.png?branch=master)](https://travis-ci.org/appmonit/app_monit_gem)

# AppMonit

## Installation

Add this line to your application's Gemfile:

    gem 'app_monit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install app_monit

## Usage

### Configure the client

    AppMonit::Config.api_key   = '<YOUR_API_KEY>'
    AppMonit::Config.end_point = 'https://api.appmon.it'
    AppMonit::Config.env       = Rails.env.to_s

### Create an event

    event_name   = 'authentication'
    payload_hash = {user: {id: 1, name: 'John'} }
    AppMonit::Event.create(event_name, payload_hash)

### Query

You can use the following metrics to query your data

* count
* count_unique
* minimum
* maximum
* average
* sum
* funnel

    AppMonit::Event.create(:registered, user: {id: '1'})
    AppMonit::Event.create(:registered, user: {id: '2'})
    AppMonit::Event.create(:purchase, user: {id: '1'}, product: { price_in_cents: 100, name: 'water', alcoholic: false })
    AppMonit::Event.create(:purchase, user: {id: '1'}, product: { price_in_cents: 150, name: 'soda', alcoholic: false })
    AppMonit::Event.create(:purchase, user: {id: '1'}, product: { price_in_cents: 200, name: 'beer', alcoholic: true })

#### count
    AppMonit::Query.count(:purchase) # { 'result' => 3 }

#### count
    AppMonit::Query.count_unique(:purchase) # { 'result' => 2, target_property: 'product.name' }

#### minimum
    AppMonit::Query.minimum(:purchase, target_property: 'product.price_in_cents') # { 'result' => 100 }

#### minimum
    AppMonit::Query.maximum(:purchase, target_property: 'product.price_in_cents') # { 'result' => 200 }

#### average
    AppMonit::Query.average(:purchase, target_property: 'product.price_in_cents') # { 'result' => 150 }

#### sum
    AppMonit::Query.sum(:purchase, target_property: 'product.price_in_cents') # { 'result' => 450 }

#### funnel
    AppMonit::Query.funnel(steps: [
        { event_collection: 'registered', actor_property: 'user.id'},
        { event_collection: 'purchase', actor_property: 'user.id'}
    ] # { 'result' => { 'result' => [ 2, 1], 'steps' => [{ event_collection: 'registered', actor_property: 'user.id'},
                                                         { event_collection: 'purchase', actor_property: 'user.id'}]

#### Timeframe
    AppMonit::Query.count('registered', timeframe: 'this_week')

Options

* this_minute
* this_hour
* this_day
* this_week
* this_month
* this_year

Or with n: this_n_minutes (n = 2 => this_2_minutes)

This can also be replaced with previous: previous_minute and previous_n_minutes

#### Interval
This can be used with timeframe
    AppMonit::Query.count('registered', timeframe: 'this_week', interval: 'daily')

* minutely
* hourly
* daily
* monthly
* yearly
* weekly

Also with n: every_n_minutes (n = 2 => every_2_minutes)

#### Group by
    AppMonit::Query.count('registered', group_by: 'alcoholic') # { 'result' => [ {'alcoholic' => true,  result => 1 }
                                                                                 {'alcoholic' => false, result => 2 }]

#### Filter
    AppMonit::Query.count('registered', filters: [{property_name: 'product.name', operator: 'eq', property_value: 'soda'}])

Allowed operators

* eq
* neq
* lt
* lte
* gt
* gte
* exists
* in
* nin

## Contributing

1. Fork it ( http://github.com/[my-github-username]/app_monit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
