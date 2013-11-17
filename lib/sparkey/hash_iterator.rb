class Sparkey::HashIterator < Sparkey::LogIterator
  def initialize(hash_reader)
    @hash_reader = hash_reader

    super @hash_reader.log_reader
  end

  def next
    handle_status Sparkey::Native.logiter_hashnext(@log_iter_ptr, @hash_reader.ptr)
  end
end
