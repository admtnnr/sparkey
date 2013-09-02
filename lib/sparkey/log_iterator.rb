class Sparkey::LogIterator
  include Sparkey::Errors

  def initialize(log_reader, hash_reader = nil)
    @log_reader = log_reader
    @hash_reader = hash_reader

    ptr = FFI::MemoryPointer.new(:pointer)

    handle_status Sparkey::Native.logiter_create(ptr, @log_reader.ptr)

    @log_iter_ptr = ptr.get_pointer(0)
  end

  def next
    handle_status Sparkey::Native.logiter_next(@log_iter_ptr, @log_reader.ptr)
  end

  def hash_next
    handle_status Sparkey::Native.logiter_hashnext(@log_iter_ptr, @hash_reader.ptr)
  end

  def state
    Sparkey::Native.logiter_state(@log_iter_ptr)
  end

  def type
    Sparkey::Native.logiter_type(@log_iter_ptr)
  end

  def <=>(iterator)
    ptr = FFI::MemoryPointer.new(:int, 1)

    handle_status Sparkey::Native.logiter_keycmp(@log_iter_ptr, interator.ptr, @log_reader.ptr, ptr)

    ptr.read_int
  end

  def active?
    state == :iter_active
  end

  def key_length
    Sparkey::Native.logiter_keylen(@log_iter_ptr)
  end

  def value_length
    Sparkey::Native.logiter_valuelen(@log_iter_ptr)
  end

  def get_key
    wanted_key_length = key_length
    key_ptr = FFI::MemoryPointer.new(:uint8, wanted_key_length)
    actual_key_length_ptr = FFI::MemoryPointer.new(:uint64, 1)

    handle_status Sparkey::Native.logiter_fill_key(@log_iter_ptr, @log_reader.ptr, wanted_key_length, key_ptr, actual_key_length_ptr)

    key_ptr.read_bytes(actual_key_length_ptr.read_uint64)
  end

  def get_value
    wanted_value_length = value_length
    value_ptr = FFI::MemoryPointer.new(:uint8, wanted_value_length)
    actual_value_length_ptr = FFI::MemoryPointer.new(:uint64, 1)

    handle_status Sparkey::Native.logiter_fill_value(@log_iter_ptr, @log_reader.ptr, wanted_value_length, value_ptr, actual_value_length_ptr)

    value_ptr.read_bytes(actual_value_length_ptr.read_uint64)
  end

  def close
    ptr = FFI::MemoryPointer.new(:pointer)
    ptr.put_pointer(0, @log_iter_ptr)

    Sparkey::Native.logiter_close(ptr)
  end

  def ptr
    @log_iter_ptr
  end
end
