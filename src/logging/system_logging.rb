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
require 'singleton'
require 'database/cassandra_dao'
require 'logging/logging'

class SystemLogging
  include Singleton
  
  def initialize
    @logger = Logging.logger
  end
  
  def self.add_log_entry(msg)
    SystemLogging.instance.add_log_entry msg
  end
  
  def add_log_entry(msg)
    Thread.new {
      @logger.debug msg
      CassandraDao.insert_log({'msg' => msg})
    }
  end
end