class Sparkey::LogReader
  include Sparkey::Errors

  def open(filename)
    log_filename = "#{filename}.spl"
    ptr = FFI::MemoryPointer.new(:pointer)

    handle_status Sparkey::Native.logreader_open(ptr, log_filename)

    @log_reader_ptr = ptr.read_pointer
  end

  def close
    ptr = FFI::MemoryPointer.new(:pointer).write_pointer(@log_reader_ptr)

    Sparkey::Native.logreader_close(ptr)
  end

  def max_key_length
    Sparkey::Native.logreader_maxkeylen(@log_reader_ptr)
  end

  def max_value_length
    Sparkey::Native.logreader_maxvaluelen(@log_reader_ptr)
  end

  def compression_type
    Sparkey::Native.logreader_compression_type(@log_reader_ptr)
  end

  def compression_blocksize
    Sparkey::Native.logreader_compression_blocksize(@log_reader_ptr)
  end

  def ptr=(ptr)
    @log_reader_ptr = ptr
  end

  def ptr
    @log_reader_ptr
  end
end
