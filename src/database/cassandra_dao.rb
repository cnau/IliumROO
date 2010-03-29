=begin
  This file is part of Ilium MUD.

  Ilium MUD is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Ilium MUD is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'logging/logging'
require 'rubygems'
require 'cassandra'
require 'singleton'

include Cassandra::Constants

class CassandraDao
  include Singleton
  include Logging

  def initialize
    @dao = Cassandra.new('IliumROO')
  end

  def insert(column_family, key, row_hash, options = {})
    @dao.insert(column_family, key, row_hash, options)
    log_debug "inserting into #{column_family} : #{key} : #{row_hash}"
  end
  
  def self.insert(column_family, key, row_hash, options = {})
    CassandraDao.instance.insert(column_family, key, row_hash, options)
  end

  def get(column_family, key, *columns_and_options)
    log_debug "getting #{column_family} : #{key} : #{columns_and_options}"
    rows = @dao.get column_family, key, *columns_and_options
    log_debug "get returned #{rows}"
    rows
  end

  def self.get(column_family, key, *columns_and_options)
    CassandraDao.instance.get(column_family, key, *columns_and_options)
  end

  def remove(column_family, key, *columns_and_options)
    log_debug "removing #{column_family} : #{key} : #{columns_and_options}"
    @dao.remove column_family, key, *columns_and_options
  end

  def self.remove(column_family, key, *columns_and_options)
    CassandraDao.instance.remove(column_family, key, *columns_and_options)
  end
end