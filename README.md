# Sparkey

Ruby [FFI](https://github.com/ffi/ffi) bindings to Spotify's [Sparkey](https://github.com/spotify/sparkey) key value store.

## Installation

### Requirements
* `libsparkey` [Github](https://github.com/spotify/sparkey)

Add this line to your application's Gemfile:

    gem 'sparkey'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sparkey

## Design
This gem aims to expose all of Sparkey's native functionality to Ruby via [FFI](https://github.com/ffi/ffi) bindings.

Additionally, it provides higher-level abstractions around the native functionality to provide a more idiomatic Ruby interface.

## Low Level
`Sparkey::Native` is intended to expose the raw C functions from Sparkey to Ruby via FFI and nothing more.

Use this interface if you are adding Ruby classes and methods to expose new Sparkey functionality. A solid understanding of the [FFI](https://github.com/ffi/ffi) API will be required.

`Sparkey::Native` should wrap all available functions from [sparkey.h](https://github.com/spotify/sparkey/blob/master/src/sparkey.h). If you find one missing please submit a Pull Request.

## Mid Level
This gem exposes Ruby-ish versions of most of Sparkey's public data structures and their related functions.

Use these interfaces if you need more control over the specific behavior of Sparkey than the `Sparkey::Store` API provides.

## High Level
The `Sparkey::Store` API provides a very small interface for using Sparkey as a generic key value store.

Use the `Sparkey::Store` API if you only need a fast persistent key-value store and don't want to delve into Sparkey specifics.

## Usage
```ruby
  require "sparkey"

  # Creates or overwrites the Sparkey file.
  sparkey = Sparkey.create("sparkey_store")

  # Opens an existing Sparkey file.
  # sparkey = Sparkey.open("sparkey_store")

  sparkey.put("first", "Hello")
  sparkey.put("second", "World")
  sparkey.put("third", "Goodbye")
  sparkey.flush

  puts sparkey.size
  #=> 3

  puts sparkey.get("second")
  #=> "World"

  sparkey.put("fourth", "Again")
  sparkey.delete("second")
  sparkey.delete("third")
  sparkey.flush

  puts sparkey.size
  #=> 2

  collector = Hash.new
  sparkey.each do |key, value|
    collector[key] = value
  end

  puts collector
  #=> { "first" => "Hello", "fourth" => "Again" }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Ensure all tests pass (`rake test`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
