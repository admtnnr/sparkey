class Sparkey::LogIterator
  include Sparkey::Errors

  def initialize(log_reader)
    @log_reader = log_reader

    ptr = FFI::MemoryPointer.new(:pointer)

    handle_status Sparkey::Native.logiter_create(ptr, @log_reader.ptr)

    @log_iter_ptr = ptr.read_pointer
  end

  def next
    handle_status Sparkey::Native.logiter_next(@log_iter_ptr, @log_reader.ptr)
  end

  def skip(count)
    handle_status Sparkey::Native.logiter_skip(@log_iter_ptr, @log_reader.ptr, count)
  end

  def reset
    handle_status Sparkey::Native.logiter_reset(@log_iter_ptr, @log_reader.ptr)
  end

  def state
    Sparkey::Native.logiter_state(@log_iter_ptr)
  end

  def type
    Sparkey::Native.logiter_type(@log_iter_ptr)
  end

  def <=>(iterator)
    ptr = FFI::MemoryPointer.new(:int)

    handle_status Sparkey::Native.logiter_keycmp(@log_iter_ptr, iterator.ptr, @log_reader.ptr, ptr)

    ptr.read_int
  end

  def new?
    state == :iter_new
  end

  def active?
    state == :iter_active
  end

  def invalid?
    state == :iter_invalid
  end

  def closed?
    state == :iter_closed
  end

  def entry_put?
    type == :entry_put
  end

  def entry_delete?
    type == :entry_delete
  end

  def key_length
    Sparkey::Native.logiter_keylen(@log_iter_ptr)
  end

  def value_length
    Sparkey::Native.logiter_valuelen(@log_iter_ptr)
  end

  def get_key
    max_key_length = @log_reader.max_key_length
    buffer_ptr = FFI::MemoryPointer.new(:uint8, max_key_length)
    buffer_length_ptr = FFI::MemoryPointer.new(:uint64)

    handle_status Sparkey::Native.logiter_fill_key(@log_iter_ptr, @log_reader.ptr, max_key_length, buffer_ptr, buffer_length_ptr)

    buffer_ptr.read_bytes(buffer_length_ptr.read_uint64)
  end

  def get_key_chunk(chunk_size = 1024)
    buffer = FFI::Buffer.alloc_out(:uint8, chunk_size)
    buffer_length_ptr = FFI::MemoryPointer.new(:uint64)

    loop do
      handle_status Sparkey::Native.logiter_keychunk(@log_iter_ptr, @log_reader.ptr, chunk_size, buffer, buffer_length_ptr)

      buffer_length = buffer_length_ptr.read_uint64

      break if buffer_length.zero?

      yield buffer.read_pointer.read_bytes(buffer_length)
    end
  end

  def get_value
    max_value_length = @log_reader.max_value_length
    buffer_ptr = FFI::MemoryPointer.new(:uint8, max_value_length)
    buffer_length_ptr = FFI::MemoryPointer.new(:uint64)

    handle_status Sparkey::Native.logiter_fill_value(@log_iter_ptr, @log_reader.ptr, max_value_length, buffer_ptr, buffer_length_ptr)

    buffer_ptr.read_bytes(buffer_length_ptr.read_uint64)
  end

  def get_value_chunk(chunk_size = 1024)
    buffer = FFI::Buffer.alloc_out(:uint8, chunk_size)
    buffer_length_ptr = FFI::MemoryPointer.new(:uint64)

    loop do
      handle_status Sparkey::Native.logiter_valuechunk(@log_iter_ptr, @log_reader.ptr, chunk_size, buffer, buffer_length_ptr)

      buffer_length = buffer_length_ptr.read_uint64

      break if buffer_length.zero?

      yield buffer.read_pointer.read_bytes(buffer_length)
    end
  end

  def close
    ptr = FFI::MemoryPointer.new(:pointer).write_pointer(@log_iter_ptr)

    Sparkey::Native.logiter_close(ptr)
  end

  def ptr
    @log_iter_ptr
  end
end
