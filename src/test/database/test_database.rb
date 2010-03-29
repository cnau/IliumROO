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
require 'minitest/autorun'
require 'database/cassandra_dao'

class TestDatabase < MiniTest::Unit::TestCase
  include Logging

  def test_log_cf
    # begin basic log cf tests
    log_debug 'beginning basic log cf tests'
    CassandraDao.remove :log, 'test'    # clean out test tag in scf

    row_id = UUID.new
    ins = CassandraDao.insert :log, 'test', {row_id => {'log_id' => row_id.to_guid.to_s, 'msg' => 'test msg'}}
    assert ins, 'insert operation should return true'

    rows = CassandraDao.get :log, 'test'
    refute_empty rows, 'make sure returned row is not empty'
    assert rows.length == 1, 'make sure 1 row was returned'

    row = CassandraDao.get :log, 'test', row_id
    refute_empty row

    assert_equal row['log_id'],  row_id.to_guid.to_s, 'make sure returned row matches sent row'
    assert_equal row['msg'],    'test msg',           'make sure returned row matches sent row'

    CassandraDao.remove :log, 'test'
    row = CassandraDao.get :log, 'test'
    assert_empty row, 'make sure row was removed'
  end

  def test_objects_cf
    # begin basic object cf tests
    log_debug 'beginning basic object cf tests'
    CassandraDao.remove :objects, 'unit_test_key_1'

    ins = CassandraDao.insert :objects, 'unit_test_key_1', {'object_id' => 'unit test 1', 'columns' => 'additional'}
    assert ins, 'insert operation should return true'

    row = CassandraDao.get :objects, 'unit_test_key_1'
    refute_empty row, 'make sure returned row is not empty'
    assert_equal row['object_id'],  'unit test 1',  'make sure returned row matches sent row'
    assert_equal row['columns'],    'additional',   'make sure returned row matches sent row'

    CassandraDao.remove :objects, 'unit_test_key_1'
    row = CassandraDao.get :objects, 'unit_test_key_1'
    assert_empty row, 'make sure row was removed'
  end

  def test_object_tags_scf
    # begin basic object_tags scf tests
    log_debug 'beginning basic object_tags scf tests'
    CassandraDao.remove :object_tags, 'unit_testing'

    ins = CassandraDao.insert :object_tags, 'unit_testing', {'unit_test_key_1' => {'player_name' => 'unit test 1'}}
    assert ins, 'insert operation should return true'

    ins = CassandraDao.insert :object_tags, 'unit_testing', {'unit_test_key_2' => {'player_name' => 'unit test 2'}}
    assert ins, 'insert operation should return true'

    row = CassandraDao.get :object_tags, 'unit_testing'
    assert row.length == 2, 'make sure 2 rows were returned'

    CassandraDao.remove :object_tags, 'unit_testing'
    row = CassandraDao.get :object_tags, 'unit_testing'
    assert_empty row, 'make sure row was removed'
  end
end