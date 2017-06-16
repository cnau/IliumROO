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

Given /^a new system logging object$/ do
  @system_logging = SystemLogging.new(@cql_dao)
  @system_logging.should_not be_nil
end

Then /^that system logging object should be valid$/ do
  @system_logging.valid?.should be_true
end

When /^I insert a log$/ do
  @log_id = @system_logging.add_log_entry 'test log entry'
  @log_id.should_not be_nil
end

Then /^I should see my log entry$/ do
  log = @system_logging.get_log_entry @log_id
  log.should_not be_nil
  log.count.should eql 1
  log.first['log_id'].to_s.should eql @log_id
end

When /^I insert a log entry for "([^"]*)" and "([^"]*)" and "([^"]*)"$/ do |source_id, target_id, object_id|
  @log_id = @system_logging.add_log_entry 'test log entry', source_id, target_id, object_id
  @log_id.should_not be_nil
end

Then /^make sure a source log entry was added for "([^"]*)"$/ do |source_id|
  rows = @system_logging.get_source_log_entries source_id
  rows.should_not be_nil
  rows.count.should eql 1
  rows.first['msg'].should eql 'test log entry'
  rows.first['log_id'].to_s.should eql @log_id
end

Then /^make sure a target log entry was added for "([^"]*)"$/ do |target_id|
  rows = @system_logging.get_target_log_entries target_id
  rows.should_not be_nil
  rows.count.should eql 1
  rows.first['msg'].should eql 'test log entry'
  rows.first['log_id'].to_s.should eql @log_id
end

Then /^make sure an object log entry was added for "([^"]*)"$/ do |object_id|
  rows = @system_logging.get_object_log_entries object_id
  rows.should_not be_nil
  rows.count.should eql 1
  rows.first['msg'].should eql 'test log entry'
  rows.first['log_id'].to_s.should eql @log_id
end