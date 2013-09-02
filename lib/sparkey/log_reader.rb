class Sparkey::LogReader
  include Sparkey::Errors

  def open(filename)
    log_filename = "#{filename}.spl"
    ptr = FFI::MemoryPointer.new(:pointer)

    handle_status Sparkey::Native.logreader_open(ptr, log_filename)

    @log_reader_ptr = ptr.get_pointer(0)
  end

  def close
    ptr = FFI::MemoryPointer.new(:pointer)
    ptr.put_pointer(0, @log_reader_ptr)

    Sparkey::Native.logreader_close(ptr)
  end

  def max_key_length
    Sparkey::Native.logreader_maxkeylen(@log_reader_ptr)
  end

  def max_value_length
    Sparkey::Native.logreader_maxvaluelen(@log_reader_ptr)
  end

  def ptr=(ptr)
    @log_reader_ptr = ptr
  end

  def ptr
    @log_reader_ptr
  end
end
