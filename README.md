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


```ruby
AppMonit::Config.api_key   = '<YOUR_API_KEY>'
AppMonit::Config.end_point = 'https://api.appmon.it'
AppMonit::Config.env       = Rails.env.to_s
```

### Create an event

```ruby
event_name   = 'authentication'
payload_hash = { user: { id: 1, name: 'John' } }

AppMonit::Event.create(event_name, payload_hash)
```

### Query

You can use the following metrics to query your data:

* `#count`
* `#count_unique`
* `#minimum`
* `#maximum`
* `#average`
* `#sum`
* `#funnel`

Example data:

```ruby
AppMonit::Event.create(:registered, user: { id: '1' })
AppMonit::Event.create(:registered, user: { id: '2' })

AppMonit::Event.create(:purchase, user: { id: '1' }, product: { price_in_cents: 100, name: 'water', alcoholic: false })
AppMonit::Event.create(:purchase, user: { id: '1' }, product: { price_in_cents: 150, name: 'soda', alcoholic: false })
AppMonit::Event.create(:purchase, user: { id: '1' }, product: { price_in_cents: 200, name: 'beer', alcoholic: true })
```

#### `#count`

```ruby
AppMonit::Query.count(:purchase) #=> { 'result' => 3 }
```

#### `#count_unique`

```ruby
AppMonit::Query.count_unique(:purchase) #=> { 'result' => 2, target_property: 'product.name' }
```

#### `#minimum`

```ruby
AppMonit::Query.minimum(:purchase, target_property: 'product.price_in_cents') #=> { 'result' => 100 }
```

#### `#maximum`

```ruby
AppMonit::Query.maximum(:purchase, target_property: 'product.price_in_cents') #=> { 'result' => 200 }
```

#### `#average`

```ruby
AppMonit::Query.average(:purchase, target_property: 'product.price_in_cents') #=> { 'result' => 150 }
```

#### `#sum`

```ruby
AppMonit::Query.sum(:purchase, target_property: 'product.price_in_cents') #=> { 'result' => 450 }
```

#### `#funnel`

```ruby
AppMonit::Query.funnel(steps: [
  { event_collection: 'registered', actor_property: 'user.id'},
  { event_collection: 'purchase', actor_property: 'user.id'}
  ]) #=> { 'result' => { 'result' => [ 2, 1], 'steps' => [{ event_collection: 'registered', actor_property: 'user.id'},
                                                          { event_collection: 'purchase', actor_property: 'user.id'}]
```

#### Timeframe

You can specify a timeframe when querying your data:

```ruby
AppMonit::Query.count('registered', timeframe: 'this_week')
```

You can use the following options to specify the timeframe:

* this_minute
* this_hour
* this_day
* this_week
* this_month
* this_year
* this_n_minutes (example: with n = 2 results this_2_minutes)

In addition to using the word 'this' to specify the timeframe, you can also use the word 'previous' (example: previous_minute, previous_day and with n = 3 the previous_3_minutes).


#### Interval
You can specify an interval when querying your data in combination with a timeframe:

```ruby
AppMonit::Query.count('registered', timeframe: 'this_week', interval: 'daily')
```
You can use the following options to specify the interval:

* minutely
* hourly
* daily
* monthly
* yearly
* weekly
* every_n_minutes (example: with n = 3 results every_3_minutes)


#### Group by

You can specify a group when querying your data:

```ruby
AppMonit::Query.count('registered', group_by: 'alcoholic') #=> { 'result' => [{ 'alcoholic' => true,  result => 1 }
 { 'alcoholic' => false, result => 2 }]
                                                                                 ```

#### Filter

You can specify a filter when querying your data:

AppMonit::Event.create(:purchase, user: { id: '1' }, product: { price_in_cents: 150, name: 'soda', alcoholic: false })

```ruby
AppMonit::Query.count('registered', filters: [{ property_name: 'product.name', operator: 'eq', property_value: 'soda' }]) #=> { 'result' => 1 }
```

You can use the following operators:

| Operator | Matcher
| -------- | --------------------------- |
| eq       | equal                       |
| neq      | not equal                   |
| lt       | less than                   |
| lte      | less than or equal to       |
| gt       | greater than                |
| gte      | greater than or equal to    |
| exists   | exists                      |
| in       | in                          |
| nin      | not in                      |


## Contributing

1. Fork it ( http://github.com/[my-github-username]/app_monit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
