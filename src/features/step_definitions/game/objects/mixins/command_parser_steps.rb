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
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"

Given /^a mocked player object for test one$/ do
  @player_klass_1 = mock
  @player_klass_1.stubs(:verbs).returns({})

  @player_obj_1 = mock
  @player_obj_1.stubs(:last_client_data).returns("")
  @player_obj_1.stubs(:class).returns(@player_klass_1)
  @player_obj_1.expects(:send_to_client).with("huh?\n")
end

When /^I parse a zero length command$/ do
  CommandParser.process_command @player_obj_1
end

Then /^I should receive huh\?$/ do
  #NOOP mocha will complain if huh? is not sent
end

Given /^a mocked player object for test two$/ do
  @player_klass_2 = mock
  @player_klass_2.stubs(:verbs).returns({})
  
  @player_obj_2 = mock
  @player_obj_2.stubs(:last_client_data).returns("command")
  @player_obj_2.stubs(:class).returns(@player_klass_2)
  @player_obj_2.expects(:send_to_client).with("huh?\n")
end

When /^I parse an invalid command$/ do
  CommandParser.process_command @player_obj_2
end

Given /^a mocked player object for test three$/ do
  @player_klass_3 = mock
  @player_klass_3.stubs(:verbs).returns({:command => nil})

  @player_obj_3 = mock
  @player_obj_3.stubs(:last_client_data).returns("command")
  @player_obj_3.stubs(:class).returns(@player_klass_3)
  arg_hash = {:verb => 'command',
              :verbsym  => :command,
              :aliasname=> 'command',
              :aliassym => :command,
              :dobjstr  => nil,
              :iobjstr  => nil,
              :prepstr  => nil,
              :prepsym  => nil,
              :player   => @player_obj_3,
              :caller   => @player_obj_3,
              :dobj     => nil,
              :iobj     => nil,
              :args     => nil}
  @player_obj_3.expects(:set_command_args).with(arg_hash)
  @player_obj_3.expects(:command)
end

When /^I parse a one word command$/ do
  CommandParser.process_command @player_obj_3
end

Then /^I should get a correct hash$/ do
  #NOOP: MOCHA will complain if the correct hash isn't sent into player obj
end

Given /^a mocked player object for test four$/ do
  @player_klass_4 = mock
  @player_klass_4.stubs(:verbs).returns({:command => nil})

  @player_obj_4 = mock
  @player_obj_4.stubs(:last_client_data).returns("command some extra text")
  @player_obj_4.stubs(:class).returns(@player_klass_4)
  @player_obj_4.expects(:command)
  arg_hash = {:verb     => 'command',
              :verbsym  => :command,
              :aliasname=> 'command',
              :aliassym => :command,
              :dobjstr  => nil,
              :iobjstr  => nil,
              :prepstr  => nil,
              :prepsym  => nil,
              :player   => @player_obj_4,
              :caller   => @player_obj_4,
              :dobj     => nil,
              :iobj     => nil,
              :args     => 'some extra text'}
  @player_obj_4.expects(:set_command_args).with(arg_hash)
end

When /^I parse a one word command with parameters$/ do
  CommandParser.process_command @player_obj_4
end

Then /^I should get a correct hash for test four$/ do
  #NOOP: mocha will complain if the proper hash doesn't come in
end

Given /^a mocked player object for test five$/ do
  @player_klass_5 = mock
  @player_klass_5.stubs(:verbs).returns({:say => nil, :emote => nil, :eval => nil})

  @player_obj_5 = mock
  @player_obj_5.stubs(:class).returns(@player_klass_5)
end

When /^I parse a command with common word replacements$/ do
  CommandParser.process_command @player_obj_5
end

Given /^a player object with last_data with a quote$/ do
  arg_hash = {:verb     => 'say',
              :verbsym  => :say,
              :aliasname=> 'say',
              :aliassym => :say,
              :dobjstr  => nil,
              :iobjstr  => nil,
              :prepstr  => nil,
              :prepsym  => nil,
              :player   => @player_obj_5,
              :caller   => @player_obj_5,
              :dobj     => nil,
              :iobj     => nil,
              :args     => 'hello there!'}

  @player_obj_5.expects(:set_command_args).with(arg_hash)
  @player_obj_5.expects(:say)
  @player_obj_5.stubs(:last_client_data).returns('" hello there!')
end

Then /^I should get a correct hash substitution with verb "([^"]*)"$/ do |verb|
  #NOOP mocha will complain if the hash is incorrect
end

Given /^a player object with last_data with a colon$/ do
  arg_hash = {:verb     => 'emote',
              :verbsym  => :emote,
              :aliasname=> 'emote',
              :aliassym => :emote,
              :dobjstr  => nil,
              :iobjstr  => 'emote',
              :prepstr  => 'to',
              :prepsym  => :to,
              :player   => @player_obj_5,
              :caller   => @player_obj_5,
              :dobj     => nil,
              :iobj     => nil,
              :args     => 'something'}

  @player_obj_5.expects(:set_command_args).with(arg_hash)
  @player_obj_5.expects(:emote)
  @player_obj_5.stubs(:last_client_data).returns(": something to emote")
end

Given /^a mocked player object for test six$/ do
  @player_klass_6 = mock
  @player_klass_6.stubs(:verbs).returns({:look => nil})

  @player_obj_6 = mock
  @player_obj_6.stubs(:class).returns(@player_klass_6)
  arg_hash = {:verb     => 'look',
              :verbsym  => :look,
              :aliasname=> 'look',
              :aliassym => :look,
              :dobjstr  => 'me',
              :iobjstr  => nil,
              :prepstr  => nil,
              :prepsym  => nil,
              :player   => @player_obj_6,
              :caller   => @player_obj_6,
              :dobj     => @player_obj_6,
              :iobj     => nil,
              :args     => nil}

  @player_obj_6.expects(:set_command_args).with(arg_hash)
  @player_obj_6.expects(:look)
end

Given /^a player object with last_data "([^"]*)" for test six$/ do |last_data|
  @player_obj_6.stubs(:last_client_data).returns last_data
end

When /^I parse the command$/ do
  CommandParser.process_command @player_obj_6
end

Then /^I should get a correct hash for test six$/ do
  #NOOP: mocha will complain if the hash is incorrect
end

Given /^a mocked player object for test seven$/ do
  @player_klass_7 = mock
  @player_klass_7.stubs(:verbs).returns({:put => {:prepositions => [:in]}})

  @player_obj_7 = mock
  @player_obj_7.stubs(:class).returns(@player_klass_7)
  arg_hash = {:verb     => 'put',
              :verbsym  => :put,
              :aliasname=> 'put',
              :aliassym => :put,
              :dobjstr  => nil,
              :iobjstr  => 'bag',
              :prepstr  => 'in',
              :prepsym  => :in,
              :player   => @player_obj_7,
              :caller   => @player_obj_7,
              :dobj     => nil,
              :iobj     => nil,
              :args     => 'sock'}

  @player_obj_7.expects(:set_command_args).with(arg_hash)
  @player_obj_7.expects(:put)
  @player_obj_7.expects(:send_to_client).with("huh?\n").twice
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
  @player_klass_8 = mock
  @player_klass_8.stubs(:verbs).returns({:put => {:aliasname => :put_in}})

  @player_obj_8 = mock
  @player_obj_8.stubs(:class).returns(@player_klass_8)
  arg_hash = {:verb     => 'put',
              :verbsym  => :put,
              :aliasname=> 'put_in',
              :aliassym => :put_in,
              :dobjstr  => nil,
              :iobjstr  => nil,
              :prepstr  => nil,
              :prepsym  => nil,
              :player   => @player_obj_8,
              :caller   => @player_obj_8,
              :dobj     => nil,
              :iobj     => nil,
              :args     => 'bag'}
  @player_obj_8.expects(:set_command_args).with(arg_hash)
  @player_obj_8.expects(:put_in)
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
  @player_klass_9 = mock
  @player_klass_9.stubs(:verbs).returns({:put => {:aliasname => :put_in}})

  @player_obj_9 = mock
  @player_obj_9.stubs(:class).returns(@player_klass_9)
  arg_hash = {:verb     => 'put',
              :verbsym  => :put,
              :aliasname=> 'put_in',
              :aliassym => :put_in,
              :dobjstr  => nil,
              :iobjstr  => 'bag',
              :prepstr  => 'in',
              :prepsym  => :in,
              :player   => @player_obj_9,
              :caller   => @player_obj_9,
              :dobj     => nil,
              :iobj     => nil,
              :args     => 'sword'}
  @player_obj_9.expects(:set_command_args).with(arg_hash)
  @player_obj_9.expects(:put_in)
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