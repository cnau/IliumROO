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
require 'database/system_logging'
require 'database/cassandra_dao'

Given /^a known number of log entries$/ do
  @start_count = SystemLogging.get_log_count
  @start_count.should_not be_nil
end

When /^I insert a log$/ do
  @log_id = SystemLogging.add_log_entry 'test log entry'
  @log_id.should_not be_nil
end

Then /^I should see my log entry$/ do
  log = SystemLogging.get_log_entry @log_id
  log['all']['log_id'].should eql @log_id.to_guid.to_s
end

And /^I should see one more log entry$/ do
  end_count = SystemLogging.get_log_count
  end_count.should eql @start_count + 1
end

Then /^I should clean up my test log$/ do
  SystemLogging.remove_log_entry @log_id

  end_count = SystemLogging.get_log_count
  end_count.should eql @start_count
end

Given /^a start count for system log$/ do
  @start_count = SystemLogging.get_log_count
  @start_count.should_not be_nil
end

And /^a clean log entry for "([^"]*)"$/ do |source_id|
  CassandraDao.remove :log, source_id
end

And /^there are no test log entries for "([^"]*)"$/ do |source_id|
  @start_source_count = SystemLogging.get_log_count source_id
  @start_source_count.should eql 0
end

When /^I insert a log entry for "([^"]*)" and "([^"]*)" and "([^"]*)"$/ do |source_id, target_id, object_id|
  @log_id = SystemLogging.add_log_entry 'test log entry', source_id, target_id, object_id
  @log_id.should_not be_nil
end

Then /^make sure a log entry was added for "([^"]*)"$/ do |source_id|
  mid_source_count = SystemLogging.get_log_count source_id
  mid_source_count.should eql @start_source_count + 1
end

And /^make sure log entries for "([^"]*)" and "([^"]*)" and "([^"]*)" were inserted correctly$/ do |source_id, target_id, object_id|
  log_entry = SystemLogging.get_log_entry @log_id, source_id, target_id, object_id
  log_entry.should_not be_nil
  log_entry[source_id]['msg'].should eql 'test log entry'
  log_entry[target_id]['msg'].should eql 'test log entry'
  log_entry[object_id]['msg'].should eql 'test log entry'
end

And /^make sure one log entries for "([^"]*)" exist$/ do |source_id|
  log_entries = SystemLogging.get_log source_id
  log_entries.should_not be_nil
  log_entries.should have(1).entries
end

Then /^clean up the test log entries for "([^"]*)" and "([^"]*)" and "([^"]*)"$/ do |source_id, target_id, object_id|
  SystemLogging.remove_log_entry @log_id, source_id, target_id, object_id

  end_count = SystemLogging.get_log_count source_id
  end_count.should eql @start_source_count
end