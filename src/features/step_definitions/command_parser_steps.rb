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

  @command_hash_3 = nil
  @player_obj_3 = mock
  @player_obj_3.stubs(:last_client_data).returns("command")
  @player_obj_3.stubs(:class).returns(@player_klass_3)
  @player_obj_3.expects(:command).with(is_a(Hash)) {|command_hash| @command_hash_3 = command_hash}
end

When /^I parse a one word command$/ do
  CommandParser.process_command @player_obj_3
  @command_hash_3.should_not be_nil
  @command_hash_3.should_not be_empty
end

Then /^I should get a correct hash$/ do
  @command_hash_3.should have_key :verb
  @command_hash_3[:verb].should eql "command"

  @command_hash_3.should have_key :verbsym
  @command_hash_3[:verbsym].should eql :command

  @command_hash_3.should have_key :alias
  @command_hash_3[:alias].should eql "command"

  @command_hash_3.should have_key :aliassym
  @command_hash_3[:aliassym].should eql :command

  @command_hash_3.should have_key :dobj
  @command_hash_3[:dobj].should be_nil

  @command_hash_3.should have_key :dobjstr
  @command_hash_3[:dobjstr].should be_nil

  @command_hash_3.should have_key :iobj
  @command_hash_3[:iobj].should be_nil
  
  @command_hash_3.should have_key :iobjstr
  @command_hash_3[:iobjstr].should be_nil

  @command_hash_3.should have_key :prepstr
  @command_hash_3[:prepstr].should be_nil

  @command_hash_3.should have_key :prepsym
  @command_hash_3[:prepsym].should be_nil

  @command_hash_3.should have_key :player
  @command_hash_3[:player].should be @player_obj_3

  @command_hash_3.should have_key :caller
  @command_hash_3[:caller].should be @player_obj_3

  @command_hash_3.should have_key :args
  @command_hash_3[:args].should be_nil
end

Given /^a mocked player object for test four$/ do
  @player_klass_4 = mock
  @player_klass_4.stubs(:verbs).returns({:command => nil})

  @command_hash_4 = nil
  @player_obj_4 = mock
  @player_obj_4.stubs(:last_client_data).returns("command some extra text")
  @player_obj_4.stubs(:class).returns(@player_klass_4)
  @player_obj_4.expects(:command).with(is_a(Hash)) {|command_hash| @command_hash_4 = command_hash}
end

When /^I parse a one word command with parameters$/ do
  CommandParser.process_command @player_obj_4
  @command_hash_4.should_not be_nil
  @command_hash_4.should_not be_empty
end

Then /^I should get a correct hash for test four$/ do
  @command_hash_4.should have_key :verb
  @command_hash_4[:verb].should eql "command"

  @command_hash_4.should have_key :dobjstr
  @command_hash_4[:args].should eql "some extra text"
end

Given /^a mocked player object for test five$/ do
  @player_klass_5 = mock
  @player_klass_5.stubs(:verbs).returns({:say => nil, :emote => nil, :eval => nil})

  @command_hash_5 = nil
  @player_obj_5 = mock
  @player_obj_5.stubs(:class).returns(@player_klass_5)
  @player_obj_5.expects(:say).with(is_a(Hash)) {|command_hash| @command_hash_5 = command_hash}
  @player_obj_5.expects(:emote).with(is_a(Hash)) {|command_hash| @command_hash_5 = command_hash}
end

When /^I parse a command with common word replacements$/ do
  CommandParser.process_command @player_obj_5
  @command_hash_5.should_not be_nil
  @command_hash_5.should_not be_empty
end

Given /^a player object with last_data with a quote$/ do
  @player_obj_5.stubs(:last_client_data).returns('" hello there!')
end

Then /^I should get a correct hash substitution with verb "([^"]*)"$/ do |verb|
  @command_hash_5.should have_key :verb
  @command_hash_5[:verb].should eql verb

  @command_hash_5.should have_key :args
  @player_obj_5.last_client_data.end_with? @command_hash_5[:args].should be_true
end

Given /^a player object with last_data with a colon$/ do
  @player_obj_5.stubs(:last_client_data).returns(": something to emote")
end

Given /^a mocked player object for test six$/ do
  @player_klass_6 = mock
  @player_klass_6.stubs(:verbs).returns({:look => nil})

  @command_hash_6 = nil
  @player_obj_6 = mock
  @player_obj_6.stubs(:class).returns(@player_klass_6)
  @player_obj_6.expects(:look).with(is_a(Hash)) {|command_hash| @command_hash_6 = command_hash}
end

Given /^a player object with last_data "([^"]*)" for test six$/ do |last_data|
  @player_obj_6.stubs(:last_client_data).returns last_data
end

When /^I parse the command$/ do
  CommandParser.process_command @player_obj_6
  @command_hash_6.should_not be_nil
  @command_hash_6.should_not be_empty
end

Then /^I should get a correct hash for test six$/ do
  @command_hash_6.should have_key :verb
  @command_hash_6[:verb].should eql "look"

  @command_hash_6.should have_key :verbsym
  @command_hash_6[:verbsym].should eql :look

  @command_hash_6.should have_key :alias
  @command_hash_6[:alias].should eql "look"

  @command_hash_6.should have_key :aliassym
  @command_hash_6[:aliassym].should eql :look

  @command_hash_6.should have_key :dobjstr
  @command_hash_6[:dobjstr].should eql "me"

  @command_hash_6.should have_key :dobj
  @command_hash_6[:dobj].should be @player_obj_6
end

Given /^a mocked player object for test seven$/ do
  @player_klass_7 = mock
  @player_klass_7.stubs(:verbs).returns({:put => {:prepositions => [:in]}})

  @command_hash_7 = nil
  @player_obj_7 = mock
  @player_obj_7.stubs(:class).returns(@player_klass_7)
  @player_obj_7.expects(:put).with(is_a(Hash)) {|command_hash| @command_hash_7 = command_hash}
  @player_obj_7.expects(:send_to_client).with("huh?\n").twice
end

Given /^a player object with last_data "([^"]*)" for test seven$/ do |last_data|
  @command_hash_7 = nil
  @player_obj_7.stubs(:last_client_data).returns last_data
end

When /^I parse the command with prepositions$/ do
  CommandParser.process_command @player_obj_7
  @command_hash_7.should_not be_nil
  @command_hash_7.should_not be_empty
end

Then /^I should get a correct hash for test seven$/ do
  @command_hash_7.should have_key :verb
  @command_hash_7[:verb].should eql "put"

  @command_hash_7.should have_key :verbsym
  @command_hash_7[:verbsym].should eql :put

  @command_hash_7.should have_key :prepstr
  @command_hash_7[:prepstr].should eql "in"

  @command_hash_7.should have_key :prepsym
  @command_hash_7[:prepsym].should eql :in

  #TODO: reimplement once containers are done
  @command_hash_7.should have_key :iobjstr
  @command_hash_7[:iobjstr].should eql "bag"

  #TODO: should be :dobj, not :args.  redo once containers are done
  @command_hash_7.should have_key :args
  @command_hash_7[:args].should eql "sock"
end

When /^I parse the command without prepositions$/ do
  CommandParser.process_command @player_obj_7
  @command_hash_7.should be_nil
end

When /^I parse the command with incorrect prepositions$/ do
  CommandParser.process_command @player_obj_7
  @command_hash_7.should be_nil
end

Then /^I should receive huh\? for test seven$/ do
  #NOOP: mocha will complain if huh isn't received
end

Given /^a mocked player object for test eight$/ do
  @player_klass_8 = mock
  @player_klass_8.stubs(:verbs).returns({:put => {:alias => :put_in}})

  @command_hash_8 = nil
  @player_obj_8 = mock
  @player_obj_8.stubs(:class).returns(@player_klass_8)
  @player_obj_8.expects(:put_in).with(is_a(Hash)) {|command_hash| @command_hash_8 = command_hash}
end

Given /^a player object with last_data "([^"]*)" for test eight$/ do |last_data|
  @command_hash_8 = nil
  @player_obj_8.stubs(:last_client_data).returns last_data
end

When /^I parse the command with aliases$/ do
  CommandParser.process_command @player_obj_8
  @command_hash_8.should_not be_nil
  @command_hash_8.should_not be_empty
end

Then /^I should get a correct hash for test eight$/ do
  @command_hash_8.should have_key :verb
  @command_hash_8[:verb].should eql "put"

  @command_hash_8.should have_key :verbsym
  @command_hash_8[:verbsym].should eql :put

  @command_hash_8.should have_key :alias
  @command_hash_8[:alias].should eql "put_in"

  @command_hash_8.should have_key :aliassym
  @command_hash_8[:aliassym].should eql :put_in
end

Given /^a mocked player object for test nine$/ do
  @player_klass_9 = mock
  @player_klass_9.stubs(:verbs).returns({:put => {:alias => :put_in}})

  @command_hash_9 = nil
  @player_obj_9 = mock
  @player_obj_9.stubs(:class).returns(@player_klass_9)
  @player_obj_9.expects(:put_in).with(is_a(Hash)) {|command_hash| @command_hash_9 = command_hash}
end

Given /^a player object with last_data "([^"]*)" for test nine$/ do |last_data|
  @command_hash_9 = nil
  @player_obj_9.stubs(:last_client_data).returns last_data
end

When /^I parse the command with aliases and prepositions$/ do
  CommandParser.process_command @player_obj_9
  @command_hash_9.should_not be_nil
  @command_hash_9.should_not be_empty
end

Then /^I should get a correct hash for test nine$/ do
  @command_hash_9.should have_key :verb
  @command_hash_9[:verb].should eql "put"

  @command_hash_9.should have_key :verbsym
  @command_hash_9[:verbsym].should eql :put

  @command_hash_9.should have_key :alias
  @command_hash_9[:alias].should eql "put_in"

  @command_hash_9.should have_key :aliassym
  @command_hash_9[:aliassym].should eql :put_in

  #TODO:reimplement once containers are done..  should be dobj
  @command_hash_9.should have_key :args
  @command_hash_9[:args].should eql "sword"

  #TODO:reimplement once container are done.. should also check iobj
  @command_hash_9.should have_key :iobjstr

  @command_hash_9.should have_key :prepstr
  @command_hash_9[:prepstr].should eql "in"

  @command_hash_9.should have_key :prepsym
  @command_hash_9[:prepsym].should eql :in
end