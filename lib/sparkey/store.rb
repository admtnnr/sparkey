class Sparkey::Store
  attr_accessor :filename, :log_writer, :log_reader,
    :hash_writer, :hash_reader

  def self.create(filename, compression_type = :compression_none, block_size = 1000)
    store = new(filename)

    store.log_writer = Sparkey::LogWriter.new
    store.log_writer.create(filename, compression_type, block_size)

    store.log_reader = Sparkey::LogReader.new
    store.log_reader.open(filename)

    store.hash_writer = Sparkey::HashWriter.new
    store.hash_writer.create(filename)

    store.hash_reader = Sparkey::HashReader.new
    store.hash_reader.open(filename)

    store
  end

  def self.open(filename)
    store = new(filename)

    store.log_writer = Sparkey::LogWriter.new
    store.log_writer.open(filename)

    store.log_reader = Sparkey::LogReader.new
    store.log_reader.open(filename)

    store.hash_writer = Sparkey::HashWriter.new
    store.hash_writer.create(filename)

    store.hash_reader = Sparkey::HashReader.new
    store.hash_reader.open(filename)

    store
  end

  def initialize(filename)
    @filename = filename
  end

  def close
    log_writer.close
    log_reader.close
    hash_reader.close
  end

  def size
    hash_reader.entry_count
  end

  def get(key)
    iterator = hash_reader.seek(key)

    return unless iterator.active?

    iterator.value
  end

  def hash_entries
    iterator = Sparkey::HashIterator.new(hash_reader)

    loop do
      return to_enum(:hash_entries) unless block_given?

      iterator.next

      break unless iterator.active?

      yield iterator.key, iterator.value
    end

    iterator.close
  end
  alias_method :each, :hash_entries

  def log_entries
    iterator = Sparkey::LogIterator.new(log_reader)

    loop do
      return to_enum(:log_entries) unless block_given?

      iterator.next

      break unless iterator.active?

      yield iterator.key, iterator.value, iterator.type
    end

    iterator.close
  end

  def put(key, value)
    log_writer.put(key, value)
  end

  def delete(key)
    log_writer.delete(key)
  end

  def flush
    log_writer.flush

    # Reset to flush cached headers
    log_reader.open(filename)
    hash_writer.create(filename)
    hash_reader.open(filename)
  end
end
