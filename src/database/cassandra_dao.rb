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
require 'logging/logging'
require 'rubygems'
require 'cassandra'
require 'singleton'

include Cassandra::Constants

# This class wraps database calls to Cassandra.  The methods are basically pass throughs
# with the exception of the keyspace being already set instead of passed into the methods.
class CassandraDao
  include Singleton
  include Logging

  def initialize
    @dao = Cassandra.new('IliumROO')
  end

  # inserts into a particular column family
  # [column_family] the column family to insert into
  # [key] they key into the column family
  # [row_hash] the hash table of the row to insert
  # [options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def insert(column_family, key, row_hash, options = {})
    log_debug "inserting into #{column_family} : #{key} : #{row_hash}"
    @dao.insert(column_family, key, row_hash, options)
  end
  
  # inserts into a column family
  # [column_family] the column family to insert into
  # [key] they key into the column family
  # [row_hash] the hash table of the row to insert
  # [options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def self.insert(column_family, key, row_hash, options = {})
    CassandraDao.instance.insert(column_family, key, row_hash, options)
  end

  # retrieves a recordset from a column family
  # [column_family] the column family to get from
  # [key] the key to retrieve
  # [columns_and_options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def get(column_family, key, *columns_and_options)
    log_debug "getting #{column_family} : #{key} : #{columns_and_options}"
    rows = @dao.get column_family, key, *columns_and_options
    log_debug "get returned #{rows}"
    rows
  end

  # retrieves a recordset from a column family
  # [column_family] the column family to get from
  # [key] the key to retrieve
  # [columns_and_options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def self.get(column_family, key, *columns_and_options)
    CassandraDao.instance.get(column_family, key, *columns_and_options)
  end

  # removes a recordset from a column family
  # [column_family] the column family to remove from
  # [key] the key to remove
  # [columns_and_options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def remove(column_family, key, *columns_and_options)
    log_debug "removing #{column_family} : #{key} : #{columns_and_options}"
    @dao.remove column_family, key, *columns_and_options
  end

  # removes a recordset from a column family
  # [column_family] the column family to remove from
  # [key] the key to remove
  # [columns_and_options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def self.remove(column_family, key, *columns_and_options)
    CassandraDao.instance.remove(column_family, key, *columns_and_options)
  end

  # returns a column count from a column family
  # [column_family] the column family to count
  # [key] the key to count
  # [columns_and_options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def count_columns(column_family, key, *columns_and_options)
    log_debug "counting columns for #{column_family} : #{key} : #{columns_and_options}"
    log_count = @dao.count_columns column_family, key, *columns_and_options
    log_debug "found #{log_count} for #{column_family} : #{key}"
    log_count
  end

  # returns a column count from a column family
  # [column_family] the column family to count
  # [key] the key to count
  # [columns_and_options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def self.count_columns(column_family, key, *columns_and_options)
    CassandraDao.instance.count_columns column_family, key, *columns_and_options
  end

  def clear_keyspace!(options = {})
    @dao.clear_keyspace! options
  end

  def self.clear_keyspace!(options = {})
    CassandraDao.instance.clear_keyspace! options
  end

  def clear_column_family!(column_family, options = {})
    @dao.clear_column_family column_family, options
  end

  def self.clear_column_family!(column_family, options = {})
    CassandraDao.instance.clear_column_family column_family, options
  end
end