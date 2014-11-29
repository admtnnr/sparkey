require "minitest/autorun"
require "sparkey"
require "sparkey/testing"

describe Sparkey::Store do
  include Sparkey::Testing

  before { @filename = random_filename }
  after  { delete(@filename) }

  it "creates a Sparkey log file" do
    sparkey = Sparkey::Store.create(@filename, :compression_snappy, 100)

    File.exists?("#{@filename}.spl").must_equal(true)
  end

  it "sets values to keys" do
    sparkey = Sparkey.create(@filename)

    sparkey.put("first", "Michael")
    sparkey.flush

    sparkey.get("first").must_equal("Michael")
  end

  it "deletes keys" do
    sparkey = Sparkey.create(@filename)
    sparkey.put("first", "Michael")
    sparkey.put("middle", "Adam")
    sparkey.flush

    sparkey.delete("first")
    sparkey.flush

    sparkey.get("first").must_be_nil
  end

  it "has the size" do
    sparkey = Sparkey.create(@filename)
    sparkey.put("middle", "Adam")
    sparkey.put("last", "Tanner")
    sparkey.flush

    sparkey.size.must_equal(2)
  end

  it "supports iterating through the log file" do
    sparkey = Sparkey.create(@filename)
    sparkey.put("first", "Michael")
    sparkey.put("middle", "Adam")
    sparkey.put("last", "Tanner")
    sparkey.delete("middle")
    sparkey.flush

    sparkey.log_entries.to_a.must_equal([
      ["first",  "Michael", :entry_put],
      ["middle", "Adam",    :entry_put],
      ["last",   "Tanner",  :entry_put],
      ["middle", "",        :entry_delete]
    ])
  end

  it "supports iterating through the hash file" do
    sparkey = Sparkey.create(@filename)
    sparkey.put("first", "Michael")
    sparkey.put("middle", "Adam")
    sparkey.put("last", "Tanner")
    sparkey.delete("middle")
    sparkey.flush

    sparkey.hash_entries.to_a.must_equal([
      ["first", "Michael"],
      ["last",  "Tanner"]
    ])
  end
end
