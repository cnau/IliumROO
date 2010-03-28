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

  def insert(column_family, row_id, row_hash)
    dao = Cassandra.new('IliumROO')
    #dao.insert(column_family, row_id, row_hash)
    log_debug 'inserting into #{column_family} : #{row_id} : #{row_hash}'
  end
  
  def self.insert(column_family, row_id, row_hash)
    CassandraDao.instance.insert(column_family, row_id, row_hash)
  end
  
  def self.insert_by_uuid(column_family, row_hash)
    CassandraDao.instance.insert(column_family, UUID.new, row_hash)
  end
  
  def self.insert_log(row_hash)
    CassandraDao.insert_by_uuid(:log, row_hash)
  end
  
  def self.insert_object(object_id, row_hash)
    CassandraDao.insert(:objects, object_id, row_hash)
  end
end