class Sparkey::HashWriter
  include Sparkey::Errors

  def create(filename)
    log_filename = "#{filename}.spl"
    index_filename = "#{filename}.spi"

    handle_status Sparkey::Native.hash_write(index_filename, log_filename, 0)
  end
end
