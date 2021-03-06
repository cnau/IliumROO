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

require_relative '../spec_helper'

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