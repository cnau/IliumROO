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
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require 'logging/logging'
require 'minitest/autorun'
require 'database/system_logging'
require 'database/cassandra_dao'

# database unit tests
class TestSystemLogging < MiniTest::Unit::TestCase
  include Logging

  def test_basic_system_log
    # basic log entry
    start_count = SystemLogging.get_log_count
    refute_nil start_count, 'make sure a valid count was returned'

    log_id = SystemLogging.add_log_entry 'test log entry'
    refute_nil log_id, 'make sure a valid log id was returned'

    SystemLogging.get_log_entry log_id

    SystemLogging.remove_log_entry log_id

    end_count = SystemLogging.get_log_count
    assert_equal start_count, end_count, 'make sure start and end log counts match'
  end

  def test_multiple_object_logs
    # multiple object id logs
    source_id = 'test_source_id_1'
    target_id = 'test_target_id_1'
    object_id = 'test_object_id_1'

    start_count = SystemLogging.get_log_count
    refute_nil start_count, 'make sure a valid count was returned'

    CassandraDao.remove :log, source_id
    CassandraDao.remove :log, target_id
    CassandraDao.remove :log, object_id

    start_source_count = SystemLogging.get_log_count source_id
    assert_equal 0, start_source_count, 'make sure source id start count is 0'

    log_id = SystemLogging.add_log_entry 'test log entry', source_id, target_id, object_id
    refute_nil log_id, 'make sure a valid log id was returned'

    mid_source_count = SystemLogging.get_log_count source_id
    assert_equal start_source_count + 1, mid_source_count, 'make sure a log was added'

    log_entry = SystemLogging.get_log_entry log_id, source_id, target_id, object_id
    refute_nil log_entry, 'make sure a log entry was returned'
    assert_equal log_entry[source_id]['msg'], 'test log entry', 'make sure source log message is correct'
    assert_equal log_entry[target_id]['msg'], 'test log entry', 'make sure target log message is correct'
    assert_equal log_entry[object_id]['msg'], 'test log entry', 'make sure object log message is correct'

    log_entries = SystemLogging.get_log source_id
    refute_nil log_entries, 'make sure log entries were returned'
    assert_equal 1, log_entries.length, 'make sure log count is correct'

    SystemLogging.remove_log_entry log_id, source_id, target_id, object_id

    end_count = SystemLogging.get_log_count source_id
    assert_equal start_source_count, end_count, 'make sure log was removed properly'
  end
end