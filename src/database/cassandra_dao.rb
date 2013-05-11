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
include Cassandra::Constants

# This class wraps database calls to Cassandra.  The methods are basically pass throughs
# with the exception of the keyspace being already set instead of passed into the methods.
class CassandraDao
  include Singleton
  include Logging

  def initialize
    if (!GameConfig.instance.config.nil?) && (!GameConfig.instance.config.empty?) && (!GameConfig.instance.config['cassandra'].nil?) && (!GameConfig.instance.config['cassandra'].empty?)
      keyspace = GameConfig.instance['cassandra']['keyspace']
      server = GameConfig.instance['cassandra']['server']
      port = GameConfig.instance['cassandra']['port']
    else
      keyspace = 'IliumROO'
      server = 'localhost'
      port = '9160'
    end
    log.info { "attaching to cassandra server: #{keyspace}@#{server}:#{port}" }
    @dao = Cassandra.new(keyspace, "#{server}:#{port}")
  end

  # inserts into a particular column family
  # [column_family] the column family to insert into
  # [key] they key into the column family
  # [row_hash] the hash table of the row to insert
  # [options] additional options, see http://blog.evanweaver.com/files/doc/fauna/cassandra/classes/Cassandra.html
  def insert(column_family, key, row_hash, options = {})
    log.debug { "inserting into #{column_family} : #{key} : #{row_hash}" }
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
    log.debug { "getting #{column_family} : #{key} : #{columns_and_options}" }
    rows = @dao.get column_family, key, *columns_and_options
    log.debug { "get returned #{rows}" }
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
    log.debug { "removing #{column_family} : #{key} : #{columns_and_options}" }
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
    log.debug { "counting columns for #{column_family} : #{key} : #{columns_and_options}" }
    log_count = @dao.count_columns column_family, key, *columns_and_options
    log.debug { "found #{log_count} for #{column_family} : #{key}" }
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