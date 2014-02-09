module Sparkey::Native
  extend FFI::Library

  ffi_lib ["libsparkey"]

  RETURN_CODE = enum :success, 0,
                     :internal_error, -1,

                     :file_not_found, -100,
                     :permission_denied, -101,
                     :too_many_open_files, -102,
                     :file_too_large, -103,
                     :file_already_exists, -104,
                     :file_busy, -105,
                     :file_is_directory, -106,
                     :file_size_exceeded, -107,
                     :file_closed, -108,
                     :out_of_disk, -109,
                     :unexpected_eof, -110,
                     :mmap_failed, -111,

                     :wrong_log_magic_number, -200,
                     :wrong_log_major_version, -201,
                     :unsupported_log_minor_version, -202,
                     :log_too_small, -203,
                     :log_closed, -204,
                     :log_iterator_inactive, -205,
                     :log_iterator_mismatch, -206,
                     :log_iterator_closed, -207,
                     :log_header_corrupt, -208,
                     :invalid_compression_block_size, -209,
                     :invalid_compression_type, -210,

                     :wrong_hash_magic_number, -300,
                     :wrong_hash_major_version, -301,
                     :unsupported_hash_minor_version, -302,
                     :hash_too_small, -303,
                     :hash_closed, -304,
                     :file_identifier_mismatch, -305,
                     :hash_header_corrupt, -306,
                     :hash_size_invalid, -307

  COMPRESSION_TYPE = enum :compression_none,
                          :compression_snappy

  ENTRY_TYPE = enum :entry_put,
                    :entry_delete

  ITER_STATE = enum :iter_new,
                    :iter_active,
                    :iter_closed,
                    :iter_invalid


  attach_function :logwriter_create, :sparkey_logwriter_create, [:pointer, :string, COMPRESSION_TYPE, :int], RETURN_CODE
  attach_function :logwriter_append, :sparkey_logwriter_append, [:pointer, :string], RETURN_CODE

  attach_function :logwriter_put, :sparkey_logwriter_put, [:pointer, :uint64, :pointer, :uint64, :pointer], RETURN_CODE
  attach_function :logwriter_delete, :sparkey_logwriter_delete, [:pointer, :uint64, :pointer], RETURN_CODE

  attach_function :logwriter_flush, :sparkey_logwriter_flush, [:pointer], RETURN_CODE
  attach_function :logwriter_close, :sparkey_logwriter_close, [:pointer], RETURN_CODE

  attach_function :logreader_open, :sparkey_logreader_open, [:pointer, :string], RETURN_CODE
  attach_function :logreader_close, :sparkey_logreader_close, [:pointer], :void
  attach_function :logreader_maxkeylen, :sparkey_logreader_maxkeylen, [:pointer], :uint64
  attach_function :logreader_maxvaluelen, :sparkey_logreader_maxvaluelen, [:pointer], :uint64
  attach_function :logreader_compression_type, :sparkey_logreader_get_compression_type, [:pointer], COMPRESSION_TYPE
  attach_function :logreader_compression_blocksize, :sparkey_logreader_get_compression_blocksize, [:pointer], :int

  attach_function :logiter_create, :sparkey_logiter_create, [:pointer, :pointer], RETURN_CODE
  attach_function :logiter_close, :sparkey_logiter_close, [:pointer], :void
  attach_function :logiter_seek, :sparkey_logiter_seek, [:pointer, :pointer, :uint64], RETURN_CODE
  attach_function :logiter_skip, :sparkey_logiter_skip, [:pointer, :pointer, :int], RETURN_CODE
  attach_function :logiter_next, :sparkey_logiter_next, [:pointer, :pointer], RETURN_CODE
  attach_function :logiter_reset, :sparkey_logiter_reset, [:pointer, :pointer], RETURN_CODE
  attach_function :logiter_keychunk, :sparkey_logiter_keychunk, [:pointer, :pointer, :uint64, :pointer, :pointer], RETURN_CODE
  attach_function :logiter_valuechunk, :sparkey_logiter_valuechunk, [:pointer, :pointer, :uint64, :pointer, :pointer], RETURN_CODE
  attach_function :logiter_fill_key, :sparkey_logiter_fill_key, [:pointer, :pointer, :uint64, :pointer, :pointer], RETURN_CODE
  attach_function :logiter_fill_value, :sparkey_logiter_fill_value, [:pointer, :pointer, :uint64, :pointer, :pointer], RETURN_CODE
  attach_function :logiter_keycmp, :sparkey_logiter_keycmp, [:pointer, :pointer, :pointer, :pointer], RETURN_CODE
  attach_function :logiter_state, :sparkey_logiter_state, [:pointer], ITER_STATE
  attach_function :logiter_type, :sparkey_logiter_type, [:pointer], ENTRY_TYPE
  attach_function :logiter_keylen, :sparkey_logiter_keylen, [:pointer], :uint64
  attach_function :logiter_valuelen, :sparkey_logiter_valuelen, [:pointer], :uint64
  attach_function :logiter_hashnext, :sparkey_logiter_hashnext, [:pointer, :pointer], RETURN_CODE
  attach_function :logiter_close, :sparkey_logiter_close, [:pointer], :void

  attach_function :hash_write, :sparkey_hash_write, [:pointer, :string, :int], RETURN_CODE
  attach_function :hash_open, :sparkey_hash_open, [:pointer, :string, :string], RETURN_CODE
  attach_function :hash_getreader, :sparkey_hash_getreader, [:pointer], :pointer
  attach_function :hash_close, :sparkey_hash_close, [:pointer], :void
  attach_function :hash_get, :sparkey_hash_get, [:pointer, :pointer, :uint64, :pointer], RETURN_CODE
  attach_function :hash_numentries, :sparkey_hash_numentries, [:pointer], :uint64
  attach_function :hash_numcollisions, :sparkey_hash_numcollisions, [:pointer], :uint64

  attach_function :create_log_filename, :sparkey_create_log_filename, [:string], :string
  attach_function :create_index_filename, :sparkey_create_index_filename, [:string], :string

  attach_function :error_string, :sparkey_errstring, [RETURN_CODE], :string
end
