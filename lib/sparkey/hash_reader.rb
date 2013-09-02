class Sparkey::HashReader
  include Sparkey::Errors

  def open(filename)
    hash_filename = "#{filename}.spi"
    log_filename = "#{filename}.spl"
    ptr = FFI::MemoryPointer.new(:pointer)

    handle_status Sparkey::Native.hash_open(ptr, hash_filename, log_filename)

    @hash_reader_ptr = ptr.get_pointer(0)
  end

  def close
    ptr = FFI::MemoryPointer.new(:pointer)
    ptr.put_pointer(0, @hash_reader_ptr)

    Sparkey::Native.hash_close(ptr)
  end

  def seek(key)
    iterator = Sparkey::LogIterator.new(log_reader)

    key_length = key.size
    key_ptr = FFI::MemoryPointer.new(:uint8, key_length)
    key_ptr.put_bytes(0, key)

    handle_status Sparkey::Native.hash_get(@hash_reader_ptr, key_ptr, key_length, iterator.ptr)

    iterator
  end

  def size
    Sparkey::Native.hash_numentries(@hash_reader_ptr)
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
