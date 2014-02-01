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
    hash_reader.entry_count.must_equal(0)

    iterator.close
    hash_reader.close
    log_writer.close
  end

  it "has a compression type and blocksize" do
    log_writer = Sparkey::LogWriter.new
    log_writer.create(@filename, :compression_snappy, 250)

    log_reader = Sparkey::LogReader.new
    log_reader.open(@filename)

    log_reader.compression_type.must_equal(:compression_snappy)
    log_reader.compression_blocksize.must_equal(250)

    log_reader.close
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

  it "builds a log filename from an index filename" do
    Sparkey.build_log_filename("sparkey.spi").must_equal("sparkey.spl")
  end

  it "builds an index filename from a log filename" do
    Sparkey.build_index_filename("sparkey.spl").must_equal("sparkey.spi")
  end

  it "iterates over the log file" do
    log_writer = Sparkey::LogWriter.new
    log_writer.create(@filename, :compression_none, 100)

    log_writer.put("first", "Michael")
    log_writer.put("middle initial", "A.")
    log_writer.put("last", "Tanner")
    log_writer.delete("middle initial")
    log_writer.flush

    log_reader = Sparkey::LogReader.new
    log_reader.open(@filename)

    log_iterator = Sparkey::LogIterator.new(log_reader)

    log_iterator.must_be(:new?)

    log_iterator.next

    log_iterator.must_be(:active?)
    log_iterator.must_be(:entry_put?)

    log_iterator.key_length.must_equal(5)
    log_iterator.value_length.must_equal(7)

    log_iterator.get_key.must_equal("first")
    log_iterator.get_value.must_equal("Michael")

    log_iterator.next

    key, iterations = "", 0
    log_iterator.get_key_chunk(8) do |chunk|
      iterations += 1
      key << chunk
    end

    key.must_equal("middle initial")
    iterations.must_equal(2)

    value, iterations = "", 0
    log_iterator.get_value_chunk(8) do |chunk|
      iterations += 1
      value << chunk
    end

    value.must_equal("A.")
    iterations.must_equal(1)

    log_iterator.skip(4)
    log_iterator.must_be(:entry_delete?)

    log_iterator.next
    log_iterator.must_be(:closed?)

    log_iterator.close
    log_reader.close
    log_writer.close
  end

  it "iterates over the hash file" do
    log_writer = Sparkey::LogWriter.new
    log_writer.create(@filename, :compression_none, 100)

    log_writer.put("salutation", "Mr.")
    log_writer.put("first", "Michael")
    log_writer.put("middle", "Adam")
    log_writer.put("last", "Tanner")
    log_writer.delete("first")
    log_writer.flush

    hash_writer = Sparkey::HashWriter.new
    hash_writer.create(@filename)

    hash_reader = Sparkey::HashReader.new
    hash_reader.open(@filename)

    hash_reader.entry_count.must_equal(3)
    hash_reader.collision_count.must_equal(0)

    hash_iterator = Sparkey::HashIterator.new(hash_reader)

    hash_iterator.must_be(:new?)

    hash_iterator.next
    hash_iterator.must_be(:active?)

    hash_iterator.get_key.must_equal("salutation")
    hash_iterator.get_value.must_equal("Mr.")

    hash_iterator.next
    hash_iterator.get_key.must_equal("middle")
    hash_iterator.get_value.must_equal("Adam")

    seek_iterator = hash_reader.seek("last")
    seek_iterator.get_value.must_equal("Tanner")

    seek_iterator.next
    seek_iterator.must_be(:closed?)

    invalid_iterator = hash_reader.seek("first")
    invalid_iterator.must_be(:invalid?)

    invalid_iterator.close
    seek_iterator.close
    hash_iterator.close
    hash_reader.close
    log_writer.close
  end

  it "compares iterators" do
    log_writer = Sparkey::LogWriter.new
    log_writer.create(@filename, :compression_none, 100)

    log_writer.put("first", "Michael")
    log_writer.put("middle", "Adam")
    log_writer.put("last", "Tanner")
    log_writer.flush

    log_reader = Sparkey::LogReader.new
    log_reader.open(@filename)

    first_iterator = Sparkey::LogIterator.new(log_reader)
    second_iterator = Sparkey::LogIterator.new(log_reader)

    first_iterator.next
    second_iterator.next

    comparison = first_iterator <=> second_iterator
    comparison.must_equal(0)

    first_iterator.next
    comparison = first_iterator <=> second_iterator
    comparison.must_equal(1)

    first_iterator.reset
    first_iterator.next
    second_iterator.next
    comparison = first_iterator <=> second_iterator
    comparison.must_equal(-1)
  end
end
