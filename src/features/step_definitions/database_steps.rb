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

require "features/step_definitions/spec_helper.rb"
require "database/cassandra_dao.rb"

include SimpleUUID

Given /^I have a clean test category for the system log$/ do
  CassandraDao.remove :log, 'test'    # clean out test tag in scf
end

When /^I insert a new log entry$/ do
  @row_id = UUID.new
  CassandraDao.insert :log, 'test', {@row_id => {'log_id' => @row_id.to_guid.to_s, 'msg' => 'test msg'}}
end

Then /^the log entry should be the same as I inserted$/ do
  rows = CassandraDao.get :log, 'test'
  rows.should_not be_empty
  rows.length.should equal 1
end

Then /^the inserted log entry should not be empty$/ do
  row = CassandraDao.get :log, 'test', @row_id
  row.should_not be_empty
  row['log_id'].should eql @row_id.to_guid.to_s
  row['msg'].should eql 'test msg'
end

Then /^I need to clean up the system log$/ do
  CassandraDao.remove :log, 'test'
  row = CassandraDao.get :log, 'test'
  row.should be_empty
end

Given /^I have a clean objects test key$/ do
  CassandraDao.remove :objects, 'unit_test_key_1'
end

When /^I insert a new object$/ do
  @new_id_1 = UUID.new.to_guid.to_s
  CassandraDao.insert :objects, @new_id_1, {'object_id' => @new_id_1, 'columns' => 'additional'}
end

Then /^the inserted object should not be empty$/ do
  row = CassandraDao.get :objects, @new_id_1
  row.should_not be_empty
  row['object_id'].should eql @new_id_1
  row['columns'].should eql 'additional'
end

Then /^I need to clean up the test key$/ do
  CassandraDao.remove :objects, @new_id_1
  row = CassandraDao.get :objects, @new_id_1
  row.should be_empty
end

Given /^I have a clean unit testing tag$/ do
  CassandraDao.remove :object_tags, 'unit_testing'
  start_count = CassandraDao.count_columns :object_tags, 'unit_testing'
  start_count.should eql 0
end

When /^I insert two new rows$/ do
  CassandraDao.insert :object_tags, 'unit_testing', {'unit_test_key_1' => {'player_name' => 'unit test 1'}}
  CassandraDao.insert :object_tags, 'unit_testing', {'unit_test_key_2' => {'player_name' => 'unit test 2'}}
end

Then /^the there should be two rows returned$/ do
  row = CassandraDao.get :object_tags, 'unit_testing'
  row.length.should eql 2
end

And /^each row should have two columns$/ do
  mid_count = CassandraDao.count_columns :object_tags, 'unit_testing'
  mid_count.should eql 2
end

Then /^I need to clean up the test object tag$/ do
  CassandraDao.remove :object_tags, 'unit_testing'
  row = CassandraDao.get :object_tags, 'unit_testing'
  row.should be_empty

  end_count = CassandraDao.count_columns :object_tags, 'unit_testing'
  end_count.should eql 0
end