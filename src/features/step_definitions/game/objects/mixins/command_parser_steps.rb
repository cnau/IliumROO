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
$: << File.expand_path(File.dirname(__FILE__) + '/../../')

require 'features/step_definitions/spec_helper.rb'

Given /^a mocked player object for test one$/ do
  player_klass = mock
  player_klass.stubs(:verbs).returns({})

  @player_obj_1 = mock
  @player_obj_1.stubs(:last_client_data).returns('')
  @player_obj_1.stubs(:class).returns(player_klass)
  @player_obj_1.expects(:send_to_client).with("huh?\n")
end

When /^I parse a zero length command$/ do
  CommandParser.process_command @player_obj_1
end

Then /^I should receive huh\?$/ do
  #NOOP mocha will complain if huh? is not sent
end

Given /^a mocked player object for test two$/ do
  player_klass = mock
  player_klass.stubs(:verbs).returns({})
  
  @player_obj_2 = mock
  @player_obj_2.stubs(:last_client_data).returns('command')
  @player_obj_2.stubs(:class).returns(player_klass)
  @player_obj_2.expects(:send_to_client).with("huh?\n")
end

When /^I parse an invalid command$/ do
  CommandParser.process_command @player_obj_2
end

Given /^a mocked player object for test three$/ do
  command_mock = mock
  command_mock.expects(:parameters).once.returns([])
  player_klass = mock
  player_klass.stubs(:verbs).returns({:command => nil})
  player_klass.stubs(:instance_method).with(:command).returns command_mock

  @player_obj_3 = mock
  @player_obj_3.stubs(:last_client_data).returns('command')
  @player_obj_3.stubs(:class).returns(player_klass)
  @player_obj_3.expects(:command)
end

When /^I parse a one word command$/ do
  CommandParser.process_command @player_obj_3
end

Then /^I should be done$/ do
  #NOOP: MOCHA will complain if the correct hash isn't sent into player obj
end

Given /^a mocked player object for test four$/ do
  command_mock = mock
  command_mock.expects(:parameters).once.returns([[:req, :args]])
  player_klass = mock
  player_klass.stubs(:verbs).returns({:command => nil})
  player_klass.stubs(:instance_method).with(:command).returns command_mock

  @player_obj_4 = mock
  @player_obj_4.stubs(:last_client_data).returns('command foo')
  @player_obj_4.stubs(:class).returns(player_klass)
end

When /^I parse a one word command with parameters "([^"]*)"$/ do |params|
  @player_obj_4.expects(:command).once.with(params) {|actual_params| @params_4 = actual_params}
  CommandParser.process_command @player_obj_4
end

Then /^I should get correct parameter value of "([^"]*)"$/ do |param_value|
  @params_4.should eql param_value
end

Given /^a mocked player object for test five$/ do
  say_mock = mock
  say_mock.expects(:parameters).once.returns([[:req, :args]])

  emote_mock = mock
  emote_mock.expects(:parameters).once.returns([[:req, :args]])

  player_klass = mock
  player_klass.stubs(:verbs).returns({:say => nil, :emote => nil, :eval => nil})
  player_klass.stubs(:instance_method).with(:say).returns say_mock
  player_klass.stubs(:instance_method).with(:emote).returns emote_mock

  @player_obj_5 = mock
  @player_obj_5.stubs(:class).returns(player_klass)
end

When /^I parse a command with common word replacements$/ do
  CommandParser.process_command @player_obj_5
end

Given /^a player object with last_data with a quote$/ do
  @player_obj_5.expects(:say).with('hello there!')
  @player_obj_5.stubs(:last_client_data).returns('" hello there!')
end

Then /^I should get a correct hash substitution with verb "([^"]*)"$/ do |verb|
  #NOOP mocha will complain if the hash is incorrect
end

Given /^a player object with last_data with a colon$/ do
  @player_obj_5.expects(:emote).with('something')
  @player_obj_5.stubs(:last_client_data).returns(': something')
end

Given /^a mocked player object for test six$/ do
  look_mock = mock
  look_mock.expects(:parameters).once.returns([[:req, :dobj]])
  player_klass = mock
  player_klass.stubs(:verbs).returns({:look => nil})
  player_klass.expects(:instance_method).with(:look).returns look_mock

  @player_obj_6 = mock
  @player_obj_6.stubs(:class).returns(player_klass)

  @player_obj_6.expects(:look).once.with(@player_obj_6)
end

Given /^a player object with last_data "([^"]*)" for test six$/ do |last_data|
  @player_obj_6.stubs(:last_client_data).returns last_data
end

When /^I parse the command for test six$/ do
  CommandParser.process_command @player_obj_6
end

Then /^I should get a correct hash for test six$/ do
  #NOOP: mocha will complain if the hash is incorrect
end

Given /^a mocked player object for test seven$/ do
  put_mock = mock
  put_mock.expects(:parameters).once.returns([[:req, :args]])
  player_klass = mock
  player_klass.stubs(:verbs).returns({:put => {:prepositions => [:in]}})
  player_klass.expects(:instance_method).with(:put).returns put_mock

  @player_obj_7 = mock
  @player_obj_7.stubs(:class).returns(player_klass)
  @player_obj_7.expects(:send_to_client).with("huh?\n").twice
  @player_obj_7.expects(:put).once.with('sock')
end

Given /^a player object with last_data "([^"]*)" for test seven$/ do |last_data|
  @player_obj_7.stubs(:last_client_data).returns last_data
end

When /^I parse the command with prepositions$/ do
  CommandParser.process_command @player_obj_7
end

Then /^I should get a correct hash for test seven$/ do
  #NOOP: mocha will complain if the hash isn't correct
end

When /^I parse the command without prepositions$/ do
  CommandParser.process_command @player_obj_7
end

When /^I parse the command with incorrect prepositions$/ do
  CommandParser.process_command @player_obj_7
end

Then /^I should receive huh\? for test seven$/ do
  #NOOP: mocha will complain if huh isn't received
end

Given /^a mocked player object for test eight$/ do
  put_in_mock = mock
  put_in_mock.expects(:parameters).once.returns([[:req, :args]])

  player_klass = mock
  player_klass.stubs(:verbs).returns({:put => {:aliasname => :put_in}})
  player_klass.expects(:instance_method).with(:put_in).returns put_in_mock

  @player_obj_8 = mock
  @player_obj_8.stubs(:class).returns(player_klass)
  @player_obj_8.expects(:put_in).once.with('bag')
end

Given /^a player object with last_data "([^"]*)" for test eight$/ do |last_data|
  @player_obj_8.stubs(:last_client_data).returns last_data
end

When /^I parse the command with aliases$/ do
  CommandParser.process_command @player_obj_8
end

Then /^I should get a correct hash for test eight$/ do
  #NOOP: mocha will complain if an invalid hash is sent in
end

Given /^a mocked player object for test nine$/ do
  put_in_mock = mock
  put_in_mock.expects(:parameters).once.returns([[:req, :args]])
  player_klass = mock
  player_klass.stubs(:verbs).returns({:put => {:aliasname => :put_in}})
  player_klass.expects(:instance_method).with(:put_in).returns put_in_mock

  @player_obj_9 = mock
  @player_obj_9.stubs(:class).returns(player_klass)
  @player_obj_9.expects(:put_in).once.with('sword')
end

Given /^a player object with last_data "([^"]*)" for test nine$/ do |last_data|
  @player_obj_9.stubs(:last_client_data).returns last_data
end

When /^I parse the command with aliases and prepositions$/ do
  CommandParser.process_command @player_obj_9
end

Then /^I should get a correct hash for test nine$/ do
  #NOOP: mocha will complain if hash is invalid
end