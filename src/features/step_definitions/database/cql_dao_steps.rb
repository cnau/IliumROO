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

Given /^a new CQLDao object$/ do
  @cql_dao = CQLDao.new
end

Then /^that dao should be connected to the database$/ do
  @cql_dao.connected?.should be_true
end

Then /^the database should be valid$/ do
  @cql_dao.valid?.should be_true
end

Given /^a test keyspace$/ do
  game_config = mock
  GameConfig.stubs(:instance).returns(game_config)
  game_config.stubs(:config).returns({'cassandra' => {'host' => '127.0.0.1',
                                                      'thrift_port' => 9160,
                                                      'cql_port' => 9042,
                                                      'keyspace' => 'TestIliumKeyspace'}})

  game_config.stubs(:[]).with('cassandra').returns({'host' => '127.0.0.1',
                                                    'thrift_port' => 9160,
                                                    'cql_port' => 9042,
                                                    'keyspace' => 'TestIliumKeyspace'})
end

Then /^the database should be cleaned up$/ do
  @cql_dao.clear_database
end

Then /^the database should not be valid$/ do
  @cql_dao.valid?.should be_false
end

Then /^create a new table$/ do
  rs = @cql_dao.execute('CREATE TABLE test (id int, data varchar, PRIMARY KEY (id));')
end

Then /^insert a few records$/ do
  rs = @cql_dao.execute('INSERT INTO test (id, data) VALUES (1, \'some test data\');')
end

Then /^select those records$/ do
  rs = @cql_dao.execute 'SELECT * FROM test WHERE id = 1;'
  rs.should_not be_nil
  @resultset = rs
end

Then /^the records should be returned$/ do
  @resultset.should_not be_nil
  @resultset.count.should eql 1
  @resultset.first.should have_key 'id'
  @resultset.first.should have_key 'data'
  @resultset.first['id'].should eql 1
  @resultset.first['data'].should eql 'some test data'
end

Given /^a clean database$/ do
  cql_dao = CQLDao.new
  cql_dao.clear_database
end