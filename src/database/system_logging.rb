=begin
Copyright (c) 2009-2012 Christian Nau

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

# This class wraps interactions with the 'log' column family
class SystemLogging
  include SimpleUUID
  include Singleton
  include Logging

  # adds a log entry
  # [msg] log message to add
  # [source_id] optional. source object id reference to objects column family
  # [target_id] optional. target object id reference to objects column family
  # [object_id] optional. object object id reference to objects column family
  # object_id is used in the case of log messages like this: "Foo gave the sword to Bar"
  # where "Foo" is source_id, "Bar" is target_id, and "sword" is object_id
  def self.add_log_entry(msg, source_id = nil, target_id = nil, object_id = nil)
    SystemLogging.instance.add_log_entry msg, source_id, target_id, object_id
  end
  
  # adds a log entry
  # [msg] log message to add
  # [source_id] optional. source object id reference to objects column family
  # [target_id] optional. target object id reference to objects column family
  # [object_id] optional. object object id reference to objects column family
  # object_id is used in the case of log messages like this: "Foo gave the sword to Bar"
  # where "Foo" is source_id, "Bar" is target_id, and "sword" is object_id
  def add_log_entry(msg, source_id = nil, target_id = nil, object_id = nil)
    log_debug "adding log entry:#{msg}, source:#{source_id}, target:#{target_id}, object:#{object_id}"
    row_id = UUID.new
    log_row = {}
    log_row['log_id'] = row_id.to_guid.to_s
    log_row['source_id'] = source_id unless source_id.nil?
    log_row['target_id'] = target_id unless target_id.nil?
    log_row['object_id'] = object_id unless object_id.nil?
    log_row['msg'] = msg
    
    row_hash = {row_id => log_row}
    
    CassandraDao.insert :log, 'all',  row_hash
    CassandraDao.insert :log, source_id, row_hash unless source_id.nil?
    CassandraDao.insert :log, target_id, row_hash unless target_id.nil?
    CassandraDao.insert :log, object_id, row_hash unless object_id.nil?

    log_debug "add log id #{row_id.to_guid.to_s}"
    row_id    # return the log id
  end

  # removes a log entry.  log entries in 'all' super column key are always removed
  # [log_id] a UUID for the log entry to remove
  # [source_id] super column key that contains log id
  # [target_id] super column key that contains log id
  # [object_id] super column key that contains log id
  def self.remove_log_entry(log_id, source_id = nil, target_id = nil, object_id = nil)
    SystemLogging.instance.remove_log_entry log_id, source_id, target_id, object_id
  end

  # removes a log entry.  log entries in 'all' super column key are always removed
  # [log_id] a UUID for the log entry to remove
  # [source_id] super column key that contains log id
  # [target_id] super column key that contains log id
  # [object_id] super column key that contains log id
  def remove_log_entry(log_id, source_id = nil, target_id = nil, object_id = nil)
    log_debug "removing log entry:#{log_id.to_guid.to_s}, source:#{source_id}, target:#{target_id}, object:#{object_id}"
    CassandraDao.remove :log, 'all', log_id
    CassandraDao.remove :log, source_id, log_id unless source_id.nil?
    CassandraDao.remove :log, target_id, log_id unless target_id.nil?
    CassandraDao.remove :log, object_id, log_id unless object_id.nil?
  end

  # gets a log entry.  log entries in 'all' super column key are always retrieved
  # [log_id] a UUID for the log entry to get
  # [source_id] super column key that contains log id
  # [target_id] super column key that contains log id
  # [object_id] super column key that contains log id
  def self.get_log_entry(log_id, source_id = nil, target_id = nil, object_id = nil)
    SystemLogging.instance.get_log_entry log_id, source_id, target_id, object_id
  end

  # gets a log entry.  log entries in 'all' super column key are always retrieved
  # [log_id] a UUID for the log entry to get
  # [source_id] super column key that contains log id
  # [target_id] super column key that contains log id
  # [object_id] super column key that contains log id
  def get_log_entry(log_id, source_id = nil, target_id = nil, object_id = nil)
    log_debug "getting log entry:#{log_id.to_guid.to_s}, source:#{source_id}, target:#{target_id}, object:#{object_id}"
    ret = {}
    
    ret['all'] = CassandraDao.get :log, 'all', log_id
    ret[source_id] = CassandraDao.get :log, source_id, log_id unless source_id.nil?
    ret[target_id] = CassandraDao.get :log, target_id, log_id unless target_id.nil?
    ret[object_id] = CassandraDao.get :log, object_id, log_id unless object_id.nil?

    log_debug "retrieved log entries:#{ret}"

    ret
  end

  # retrieves log entries for a give super column key
  # [log_key] default 'all'. super column key to retrieve log entries for
  # [columns_and_options] optional. see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def self.get_log(log_key = 'all', *columns_and_options)
    SystemLogging.instance.get_log log_key, *columns_and_options
  end

  # retrieves log entries for a give super column key
  # [log_key] default 'all'. super column key to retrieve log entries for
  # [columns_and_options] optional. see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def get_log(log_key = 'all', *columns_and_options)
    log_debug "getting log entries for #{log_key}, #{columns_and_options}"
    entries = CassandraDao.get :log, log_key, *columns_and_options
    log_debug "got log entries #{entries}"
    entries
  end

  # retrieves count of log entries for a give super column key
  # [log_key] default 'all'. super column key to retrieve log count for
  # [columns_and_options] optional. see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def self.get_log_count(log_key = 'all', *columns_and_options)
    SystemLogging.instance.get_log_count log_key, *columns_and_options
  end

  # retrieves count of log entries for a give super column key
  # [log_key] default 'all'. super column key to retrieve log count for
  # [columns_and_options] optional. see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def get_log_count(log_key = 'all', *columns_and_options)
    log_debug "counting logs for #{log_key}, #{columns_and_options}"
    count = CassandraDao.count_columns :log, log_key, *columns_and_options
    log_debug "found #{count} logs in #{log_key}"
    count
  end
end