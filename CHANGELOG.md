# Sparkey 1.3.0 (February 9, 2014)
* `Sparkey::LogReader` API
  * Added `#compression_type` to read the compression type from the log.
  * Added `#compression_blocksize` to read the compression block size from the log.

# Sparkey 1.2.0 (January 23, 2014)
* `Sparkey` API
  * Added `::build_index_filename` to build an index file name from a log file name.

# Sparkey 1.1.0 (November 18, 2013)
* `Sparkey` API
  * Added `::build_log_filename` to build a log file name from a hash file name.
* `Sparkey::Store` API
  * Added `#each_from_log` to explicitly iterate using the log file. Will repeatedly yield the key, value, and the type of log entry to the block.
  * Added `#each_from_hash` to explicitly iterate using the hash file. Will repeatedly yield the key and value to the block.
  * Fixed `#get` to return nil if the key is not found.
  * Fixed `#flush` to also re-open the `Sparkey::LogReader` to ensure it does not receive stale entries if used for iteration.
  * Changed `#flush` to no longer accept a block.
* `Sparkey::HashReader` API
  * Renamed `#size` to `#entry_count`.
  * Added `#collision_count`.
* `Sparkey::LogIterator` API
  * Added `#new?` to check if the iterator is in a new state.
  * Added `#invalid?` to check if the iterator is in an invalid state.
  * Added `#closed?` to check if the iterator is in a closed state.
  * Added `#entry_put?` to check if the iterator log entry type is a put entry.
  * Added `#entry_delete?` to check if the iterator log entry type is a delete entry.
  * Added `#skip` to skip over a specified number of entries in a log file.
  * Added `#reset` to reset the iterator back to the beginning.
  * Added `#get_key_chunk` to enable retrieving chunks of the key without
    having to store the entire key in memory. Will repeatedly yield to the
    block the key chunk in the requested block size in bytes until the key has
    been fully consumed. Block sizes must be at least 8 bytes.
  * Added `#get_value_chunk` to enable retrieving chunks of the value without
    having to store the entire value in memory. Will repeatedly yield to the
    block the value chunk in the requested block size in bytes until the value has
    been fully consumed. Block sizes must be at least 8 bytes.
  * Fixed `#get_key` to read the maximum key length when consuming the key.
  * Fixed `#get_value` to read the maximum value length when consuming the value.
* `Sparkey::HashIterator` API
  * Added API to specifically deal with iterating through a hash reader.
  * Supports all existing `Sparkey::LogIterator` API methods.
  * Implement `#next` using the `sparkey_logiter_hashnext` function.

# Sparkey 1.0.0 (November 16, 2013)
* `Sparkey::Store` API
* `Sparkey::LogReader` API
* `Sparkey::LogWriter` API
* `Sparkey::LogIterator` API
* `Sparkey::HashReader` API
* `Sparkey::HashWriter` API
* `Sparkey::Native` API
