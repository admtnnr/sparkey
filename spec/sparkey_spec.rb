require "minitest/autorun"
require "sparkey"
require "sparkey/testing"

describe Sparkey do
  include Sparkey::Testing

  before { @filename = random_filename }
  after  { delete(@filename) }

  it "assigns values to keys" do
    log_writer = Sparkey::LogWriter.new
    log_writer.create(@filename, :compression_none, 100)

    log_writer.put("first", "Michael")
    log_writer.flush

    hash_writer = Sparkey::HashWriter.new
    hash_writer.create(@filename)

    hash_reader = Sparkey::HashReader.new
    hash_reader.open(@filename)
    iterator = hash_reader.seek("first")

    iterator.get_value.must_equal("Michael")

    iterator.close
    hash_reader.close
    log_writer.close
  end

  it "deletes keys" do
    log_writer = Sparkey::LogWriter.new
    log_writer.create(@filename, :compression_none, 100)
    log_writer.put("first", "Michael")
    log_writer.flush

    log_writer.delete("first")
    log_writer.flush

    hash_writer = Sparkey::HashWriter.new
    hash_writer.create(@filename)

    hash_reader = Sparkey::HashReader.new
    hash_reader.open(@filename)
    iterator = hash_reader.seek("first")

    iterator.must_be(:invalid?)
    hash_reader.size.must_equal(0)

    iterator.close
    hash_reader.close
    log_writer.close
  end

  it "has the max key length and max value length" do
    log_writer = Sparkey::LogWriter.new
    log_writer.create(@filename, :compression_none, 100)
    log_writer.put("middle", "Adam")
    log_writer.put("last", "Tanner")
    log_writer.flush

    log_reader = Sparkey::LogReader.new
    log_reader.open(@filename)

    log_reader.max_key_length.must_equal(6)
    log_reader.max_value_length.must_equal(6)

    log_reader.close
    log_writer.close
  end

  it "iterates over the log file"
  it "iterates over the hash file"
end
