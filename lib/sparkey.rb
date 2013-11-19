require "ffi"

module Sparkey
  def self.create(filename)
    Store.create(filename)
  end

  def self.open(filename)
    Store.open(filename)
  end

  def self.build_log_filename(hash_file)
    Sparkey::Native.create_log_filename(hash_file)
  end
end

require "sparkey/native"
require "sparkey/errors"
require "sparkey/store"
require "sparkey/log_writer"
require "sparkey/log_reader"
require "sparkey/log_iterator"
require "sparkey/hash_writer"
require "sparkey/hash_reader"
require "sparkey/hash_iterator"
