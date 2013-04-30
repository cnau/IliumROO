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
require 'game_objects/game_object_loader'
require 'game/objects/basic_named_object'

Given /^a named game object instance 1/ do
  @named_obj_1 = BasicNamedObject.new
  @named_obj_1.should_not be_nil
end

Then /^parent should be BasicNamedObject$/ do
  @named_obj_1.parent.should eql 'BasicNamedObject'
end

Given /^a named game object instance 2/ do
  @named_obj_2 = BasicNamedObject.new
  @named_obj_2.should_not be_nil
end

And /^a mocked game object save call 2$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, obj_hash| @object_hash_2 = obj_hash }
end

When /^I save it 2$/ do
  player_obj = mock
  player_obj.expects(:send_to_client).with(is_a(String)) { |msg| @client_msg_2 = msg }
  @named_obj_2.save player_obj
end

Then /^I should have the correct properties in the hash 2$/ do
  @object_hash_2.should_not be_nil
  @object_hash_2.should include :name
  @object_hash_2.should include :alias
  @object_hash_2.should include :object_tag
end

And /^I should get an appropriate output message for the user 2$/ do
  @client_msg_2.should eql "##{@object_hash_2[:game_object_id]} saved.\n"
end

Given /^a named object instance 3$/ do
  @named_obj_3 = BasicNamedObject.new
  @named_obj_3.should_not be_nil
  @named_obj_3.name = 'Named3'
end

And /^a mocked game object save call 3$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, obj_hash| @object_hash_3 = obj_hash }
end

When /^I save it 3$/ do
  player_obj = mock
  player_obj.expects(:send_to_client).with(is_a(String)) { |msg| @client_msg_3 = msg }
  @named_obj_3.save player_obj
end

Then /^I should have the correct properties in the hash 3$/ do
  @object_hash_3.should_not be_nil
  @object_hash_3.should include :name
  @object_hash_3[:name].should eql 'Named3'
end

And /^I should get an appropriate output message for the user 3$/ do
  @client_msg_3.should eql "Named3 saved.\n"
end

Given /^a named object instance 4$/ do
  @named_obj_4 = BasicNamedObject.new
  @named_obj_4.should_not be_nil
  @named_obj_4.name = 'Named4'
  @named_obj_4.object_tag = 'basic_named_object_steps'
end

And /^a mocked game object save call 4$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, obj_hash| @object_hash_4 = obj_hash }
  GameObjects.expects(:add_tag).with('basic_named_object_steps', 'Named4', is_a(Hash)) { |obj_tag, obj_name, tag_hash| @tag_hash_4 = tag_hash }
end

When /^I save it 4$/ do
  player_obj = mock
  player_obj.expects(:send_to_client).with(is_a(String)) { |msg| @client_msg_4 = msg }
  @named_obj_4.save player_obj
end

Then /^I should have the correct properties in the hash 4$/ do
  @object_hash_4.should_not be_nil
  @object_hash_4.should include :name
  @object_hash_4[:name].should eql 'Named4'

  @object_hash_4.should include :object_tag
  @object_hash_4[:object_tag].should eql 'basic_named_object_steps'

  @tag_hash_4.should_not be_nil
  @tag_hash_4.should include 'object_id'
  @tag_hash_4['object_id'].should eql @object_hash_4[:game_object_id]
end

And /^I should get an appropriate output message for the user 4$/ do
  @client_msg_4.should eql "Named4 saved.\n"
end

Given /^a named object instance 5$/ do
  @named_obj_5 = BasicNamedObject.new
  @named_obj_5.should_not be_nil
  @named_obj_5.name = 'Named5'
  @named_obj_5.alias = 'Alias5'
end

And /^a mocked game object save call 5$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, obj_hash| @object_hash_5 = obj_hash }
end

When /^I save it 5$/ do
  player_obj = mock
  player_obj.expects(:send_to_client).with(is_a(String)) { |msg| @client_msg_5 = msg }
  @named_obj_5.save player_obj
end

Then /^I should have the correct properties in the hash 5$/ do
  @object_hash_5.should_not be_nil
  @object_hash_5.should include :name
  @object_hash_5[:name].should eql 'Named5'

  @object_hash_5.should include :alias
  @object_hash_5[:alias].should eql 'Alias5'
end

And /^I should get an appropriate output message for the user 5$/ do
  @client_msg_5.should eql "Named5 saved.\n"
end

Given /^a named object instance 6$/ do
  @named_obj_6 = BasicNamedObject.new
  @named_obj_6.should_not be_nil
  @named_obj_6.name = 'Named6'
  @named_obj_6.alias = 'Alias6'
  @named_obj_6.object_tag = 'basic_named_object_steps'
end

And /^a mocked game object save call 6$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, obj_hash| @object_hash_6 = obj_hash }
  GameObjects.expects(:add_tag).with('basic_named_object_steps', 'Named6', is_a(Hash)) { |obj_tag, obj_name, tag_hash| @tag_hash_6 = tag_hash }
  GameObjects.expects(:add_tag).with('basic_named_object_steps', 'Alias6', is_a(Hash)) { |obj_tag, obj_name, tag_hash| @tag_hash_6a = tag_hash }
end

When /^I save it 6$/ do
  player_obj = mock
  player_obj.expects(:send_to_client).with(is_a(String)) { |msg| @client_msg_6 = msg }
  @named_obj_6.save player_obj
end

Then /^I should have the correct properties in the hash 6$/ do
  @object_hash_6.should_not be_nil
  @object_hash_6.should include :name
  @object_hash_6[:name].should eql 'Named6'

  @object_hash_6.should include :alias
  @object_hash_6[:alias].should eql 'Alias6'

  @tag_hash_6.should_not be_nil
  @tag_hash_6.should include 'object_id'
  @tag_hash_6['object_id'].should eql @object_hash_6[:game_object_id]

  @tag_hash_6a.should_not be_nil
  @tag_hash_6a.should include 'object_id'
  @tag_hash_6a['object_id'].should eql @object_hash_6[:game_object_id]
end

And /^I should get an appropriate output message for the user 6$/ do
  @client_msg_6.should eql "Named6 saved.\n"
end

Given /^a named object instance 7$/ do
  @named_obj_7 = BasicNamedObject.new
  @named_obj_7.should_not be_nil
  @named_obj_7.name = 'Named7'
  @named_obj_7.alias = 'Alias7'
  @named_obj_7.object_tag = 'basic_named_object_steps'
end

And /^a mocked game object save call 7$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, obj_hash| @object_hash_7 = obj_hash }
  GameObjects.expects(:add_tag).with('basic_named_object_steps', 'Named7', is_a(Hash)) { |obj_tag, obj_name, tag_hash| @tag_hash_7 = tag_hash }
  GameObjects.expects(:add_tag).with('basic_named_object_steps', 'Alias7', is_a(Hash)) { |obj_tag, obj_name, tag_hash| @tag_hash_7a = tag_hash }
  GameObjects.expects(:add_tag).with('recycled', 'Named7', is_a(Hash)) { |obj_tag, obj_name, tag_hash| @tag_hash_7b = tag_hash }
  GameObjects.expects(:remove_tag).with('basic_named_object_steps', 'Named7')
  GameObjects.expects(:remove_tag).with('basic_named_object_steps', 'Alias7')
end

When /^I save it 7$/ do
  player_obj = mock
  player_obj.expects(:send_to_client).with("Named7 saved.\n")
  @named_obj_7.save player_obj
end

And /^I recycle it$/ do
  player_obj = mock
  player_obj.expects(:send_to_client).with("Named7 recycled.\n")
  @named_obj_7.recycle player_obj
end

Then /^I should have the correct properties in the hash 7$/ do
  @object_hash_7.should_not be_nil
  @object_hash_7.should include :name
  @object_hash_7[:name].should eql 'Named7'

  @object_hash_7.should include :alias
  @object_hash_7[:alias].should eql 'Alias7'

  @tag_hash_7.should_not be_nil
  @tag_hash_7.should include 'object_id'
  @tag_hash_7['object_id'].should eql @object_hash_7[:game_object_id]

  @tag_hash_7a.should_not be_nil
  @tag_hash_7a.should include 'object_id'
  @tag_hash_7a['object_id'].should eql @object_hash_7[:game_object_id]
end
