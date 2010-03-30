#  This file is part of Ilium MUD.
#
#  Ilium MUD is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Ilium MUD is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.
require 'singleton'
require 'database/cassandra_dao'
require 'logging/logging'

# This class wraps interactions with the 'log' column family
class SystemLogging
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
    row_hash = {row_id => {'log_id'     => row_id.to_guid.to_s,
                           'source_id'  => source_id, 
                           'target_id'  => target_id,
                           'object_id'  => object_id,
                           'msg'        => msg}}
    
    CassandraDao.insert :log, 'all',  row_hash
    CassandraDao.insert :log, source_id, row_hash
    CassandraDao.insert :log, target_id, row_hash
    CassandraDao.insert :log, object_id, row_hash
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
    log_debug "removing log entry:#{log_id}, source:#{source_id}, target:#{target_id}, object:#{object_id}"
    CassandraDao.remove :log, 'all', log_id
    CassandraDao.remove :log, source_id, log_id unless source_id.nil?
    CassandraDao.remove :log, target_id, log_id unless target_id.nil?
    CassandraDao.remove :log, object_id, log_id unless object_id.nil?
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
end