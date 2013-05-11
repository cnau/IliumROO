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

require_relative '../../../spec_helper'

class AdminTester
  attr_accessor :game_object_id
  include Admin
end

Given /^a new admin object$/ do
  AdminTester.included_modules.should include Admin
  @admin_object = AdminTester.new

  AdminTester.public_instance_methods.should include :inspect_object
  AdminTester.public_instance_methods.should include :list_players
  AdminTester.public_instance_methods.should include :list_items
end

When /^I mock a player list$/ do
  @list_player_hash = {'Test' => {'object_id' => 'test_id'}}
  GameObjects.expects(:get_tag).with('player_names', nil).returns(@list_player_hash)
end

Then /^the list_players command should return the player list$/ do
  player_mock = mock
  player_msg = nil
  player_mock.expects(:send_to_client).with(is_a(String)) { |msg| player_msg = msg }

  @admin_object.list_players player_mock

  ret = 'player name'.ljust(25)
  ret << '     '
  ret << 'object id'.ljust(10)
  ret << "\n"
  @list_player_hash.each do |player_name, object_hash|
    ret << player_name.ljust(25)
    ret << '     '
    ret << object_hash['object_id'].center(10, ' ')
    ret << "\n"
  end

  player_msg.should eql ret
end

When /^I mock an item list with nil direct object$/ do
  @list_item_hash = {'TestType' => {'TestName' => {'object_id' => 'test_id'}}}
  GameObjects.expects(:get_tag).with('items', nil).returns(@list_item_hash)
end

Then /^the list_items command should return the item list with nil direct object$/ do
  ret = "items types:\n"
  @list_item_hash.each do |type_name, items|
    ret << type_name << "\n"
  end

  player_mock = mock
  player_msg = nil
  player_mock.expects(:send_to_client).with(is_a(String)) { |msg| player_msg = msg }

  @admin_object.list_items player_mock

  player_msg.should eql ret
end

When /^I mock an item list with with a direct object$/ do
  @list_item_hash = {'TestName' => {'object_id' => 'test_id'}}
  GameObjects.expects(:get_tag).with('items', 'TestType').returns(@list_item_hash)
end

Then /^the list_items command should return the item list with the correct item type$/ do
  ret = "TestType:\n"
  ret << 'item name'.ljust(25)
  ret << '     '
  ret << 'object id'.ljust(10)
  ret << "\n"
  @list_item_hash.each do |item_name, object_hash|
    ret << item_name.ljust(25)
    ret << '     '
    ret << object_hash['object_id'].center(10, ' ')
    ret << "\n"
  end

  player_mock = mock
  player_msg = nil
  player_mock.expects(:send_to_client).with(is_a(String)) { |msg| player_msg = msg }

  @admin_object.list_items player_mock, 'TestType'

  player_msg.should eql ret
end

When /^I mock an object hash$/ do
  @object_hash = {:alias => '', :game_object_id => 'test_id', :name => 'Test', :object_tag => 'test_tag', :parent => 'test_parent_id'}
  @admin_object.game_object_id = 'test_id'
  GameObjects.expects(:get).with('test_id').returns(@object_hash)
end

Then /^the inspect command should display the correct object hash$/ do
  out = "Object #{@object_hash[:game_object_id]}\n"
  out << @object_hash.inspect
  out << "\n"

  player_mock = mock
  player_msg = nil
  player_mock.expects(:send_to_client).with(is_a(String)) { |msg| player_msg = msg }

  @admin_object.inspect_object player_mock, 'test_id'

  player_msg.should eql out
end

Then /^the inspect command with dobjstr "([^"]*)" should send to player "([^"]*)"$/ do |dobjstr, the_msg|
  player_mock = mock
  player_msg = nil
  player_mock.expects(:send_to_client).with(is_a(String)) { |msg| player_msg = msg }

  @admin_object.inspect_object player_mock, dobjstr

  player_msg.chomp.should eql the_msg
end

When /^I mock an object hash with a object instance$/ do
  @object_hash = {:alias => '', :game_object_id => 'test_id', :name => 'Test', :object_tag => 'test_tag', :parent => 'test_parent_id'}
  GameObjects.expects(:get).with('test_id').returns(@object_hash)
end

When /^I mock an object hash with a bogus_id$/ do
  GameObjects.expects(:get).with('bogus_id').returns(nil)
end