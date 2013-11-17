require "minitest/autorun"
require "sparkey"
require "sparkey/testing"

describe Sparkey::Store do
  include Sparkey::Testing

  before { @filename = random_filename }
  after  { delete(@filename) }

  it "functions as a key-value store" do
    sparkey = Sparkey::Store.create(@filename, :compression_snappy, 1000)
    sparkey.put("first", "Michael")
    sparkey.put("second", "Adam")
    sparkey.put("third", "Tanner")
    sparkey.close

    sparkey = Sparkey::Store.open(@filename)

    sparkey.size.must_equal 3

    sparkey.get("first").must_equal("Michael")
    sparkey.delete("second")
    sparkey.flush

    sparkey.size.must_equal 2

    collector = Hash.new
    sparkey.each do |key, value|
      collector[key] = value
    end

    collector.must_equal("first" => "Michael", "third" => "Tanner")
  end
end
