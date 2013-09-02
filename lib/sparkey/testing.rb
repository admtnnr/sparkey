require "securerandom"

module Sparkey::Testing
  def random_filename
    "test-#{SecureRandom.hex(16)}"
  end

  def delete(filename)
    log_file = "#{filename}.spl"
    index_file = "#{filename}.spi"

    File.delete(log_file)   if File.exists?(log_file)
    File.delete(index_file) if File.exists?(index_file)
  end
end
