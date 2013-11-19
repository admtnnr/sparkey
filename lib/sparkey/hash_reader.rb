class Sparkey::HashReader
  include Sparkey::Errors

  def open(filename)
    hash_filename = "#{filename}.spi"
    log_filename = "#{filename}.spl"
    ptr = FFI::MemoryPointer.new(:pointer)

    handle_status Sparkey::Native.hash_open(ptr, hash_filename, log_filename)

    @hash_reader_ptr = ptr.read_pointer
  end

  def close
    ptr = FFI::MemoryPointer.new(:pointer).write_pointer(@hash_reader_ptr)

    Sparkey::Native.hash_close(ptr)
  end

  def seek(key)
    iterator = Sparkey::HashIterator.new(self)

    key_length = key.bytesize
    key_ptr = FFI::MemoryPointer.new(:uint8, key_length).write_bytes(key)

    handle_status Sparkey::Native.hash_get(@hash_reader_ptr, key_ptr, key_length, iterator.ptr)

    iterator
  end

  def entry_count
    Sparkey::Native.hash_numentries(@hash_reader_ptr)
  end

  def collision_count
    Sparkey::Native.hash_numcollisions(@hash_reader_ptr)
  end

  def log_reader
    reader_ptr = Sparkey::Native.hash_getreader(@hash_reader_ptr)

    log_reader = Sparkey::LogReader.new
    log_reader.ptr = reader_ptr

    log_reader
  end

  def ptr
    @hash_reader_ptr
  end
end
