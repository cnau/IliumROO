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
  include Logging

  COLUMNFAMILY_NAME = 'system_logging'

  def valid?
    @valid
  end

  def initialize(cql_dao = nil)
    @cql_dao = cql_dao
    if !validate_database
      build_database
    end
  end

  def build_database
    log.debug { "creating columnfamily #{COLUMNFAMILY_NAME}" }
    # no columnfamily, so create one
    @cql_dao.execute "CREATE TABLE #{COLUMNFAMILY_NAME} (log_id TimeUUID PRIMARY KEY, source_id varchar, target_id varchar, object_id varchar, msg varchar)"
    # create secondary indexes
    @cql_dao.execute "CREATE INDEX ON #{COLUMNFAMILY_NAME} (source_id)"
    @cql_dao.execute "CREATE INDEX ON #{COLUMNFAMILY_NAME} (target_id)"
    @cql_dao.execute "CREATE INDEX ON #{COLUMNFAMILY_NAME} (object_id)"
    @valid = true
  end

  def validate_database
    @valid = false
    result = @cql_dao.execute "SELECT columnfamily_name FROM system.schema_columnfamilies WHERE keyspace_name = '#{@cql_dao.keyspace}' AND columnfamily_name = '#{COLUMNFAMILY_NAME}'"
    @valid = !(result.nil? or result.empty?)
    @valid
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
    row_id = UUID.new.to_guid.to_s
    rs = @cql_dao.execute "INSERT INTO #{COLUMNFAMILY_NAME} (log_id, source_id, target_id, object_id, msg) VALUES (#{row_id}, '#{source_id}', '#{target_id}', '#{object_id}', '#{msg}')"
    log_debug "added log id #{row_id}"
    row_id # return the log id
  end

  # removes a log entry.  log entries in 'all' super column key are always removed
  # [log_id] a UUID for the log entry to remove
  def remove_log_entry(log_id)
    log_debug "removing log entry:#{log_id}"
    @cql_dao.execute "DELETE FROM #{COLUMNFAMILY_NAME} WHERE log_id = #{log_id}"
  end

  def get_log_entry(log_id)
    log_debug "getting log entry:#{log_id}"
    @cql_dao.execute("SELECT log_id, source_id, target_id, object_id, msg FROM #{COLUMNFAMILY_NAME} WHERE log_id = #{log_id}")
  end

  def get_source_log_entries(source_id)
    log_debug "getting source log entry:#{source_id}"
    @cql_dao.execute("SELECT log_id, source_id, target_id, object_id, msg FROM #{COLUMNFAMILY_NAME} WHERE source_id = '#{source_id}'")
  end

  def get_target_log_entries(target_id)
    log_debug "getting target log entry:#{target_id}"
    @cql_dao.execute("SELECT log_id, source_id, target_id, object_id, msg FROM #{COLUMNFAMILY_NAME} WHERE target_id = '#{target_id}'")
  end

  def get_object_log_entries(object_id)
    log_debug "getting object log entry:#{object_id}"
    @cql_dao.execute("SELECT log_id, source_id, target_id, object_id, msg FROM #{COLUMNFAMILY_NAME} WHERE object_id = '#{object_id}'")
  end
end