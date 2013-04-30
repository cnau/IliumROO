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
require 'game/objects/basic_game_object'

Given /^a BasicGameObject class$/ do
  @test_klass = BasicGameObject
end

When /^I request verbs$/ do
  @klass_verbs = @test_klass.verbs
end

When /^I request properties$/ do
  @klass_properties = @test_klass.properties
end

Then /^I should get appropriate values$/ do
  @klass_properties.should eql [:game_object_id]
end

Given /^a new BasicGameObject instance$/ do
  @basic_game_object_1 = BasicGameObject.new
  @basic_game_object_1.should_not be_nil
  @basic_game_object_1.should be_an_instance_of BasicGameObject
end

When /^I check game object id$/ do
  @game_object_id = @basic_game_object_1.game_object_id
  @game_object_id.should_not be_nil
end

Then /^I should get a valid game object id$/ do
  m = @game_object_id.match /^[0-9a-fA-F]{9}$/
  m.should_not be_nil
end

Then /^I should be able to see that id in the object's to_h function$/ do
  obj_hash = @basic_game_object_1.to_h
  obj_hash.should_not be_nil
  obj_hash.should have_key :game_object_id
  obj_hash[:game_object_id].should eql @game_object_id
end

Given /^an instance of BasicGameObject 3$/ do
  @basic_game_object_4 = BasicGameObject.new
  @basic_game_object_4.should_not be_nil
  @basic_game_object_4.should be_an_instance_of BasicGameObject
end

When /^I mock a couple of state classes$/ do
  @mock_state_1 = mock
  @mock_state_instance_1 = mock
  @mock_state_1.expects(:instance).returns(@mock_state_instance_1).twice
  @mock_state_instance_1.expects(:class).returns(@mock_state_1).times(3)
  @mock_state_instance_1.expects(:enter).with(@basic_game_object_4).twice
  @mock_state_instance_1.expects(:execute).with(@basic_game_object_4)
  @mock_state_instance_1.expects(:exit).with(@basic_game_object_4)

  @mock_state_2 = mock
  @mock_state_instance_2 = mock
  @mock_state_2.expects(:instance).returns(@mock_state_instance_2)
  @mock_state_instance_2.expects(:enter).with(@basic_game_object_4)
  @mock_state_instance_2.expects(:class).returns(@mock_state_2)
  @mock_state_instance_2.expects(:execute).with(@basic_game_object_4)
  @mock_state_instance_2.expects(:exit).with(@basic_game_object_4)
end

When /^I change the state of BasicGameObject$/ do
  @basic_game_object_4.change_state @mock_state_1
  @basic_game_object_4.in_state?(@mock_state_1).should be_true
  @basic_game_object_4.update

  @basic_game_object_4.change_state @mock_state_2
  @basic_game_object_4.in_state?(@mock_state_2).should be_true
  @basic_game_object_4.update
end

Then /^I expect the state changes to take place$/ do
  @basic_game_object_4.current_state.should be @mock_state_instance_2
  @basic_game_object_4.previous_state.should be @mock_state_instance_1
end

When /^I revert the state$/ do
  @basic_game_object_4.revert_to_previous_state
  @basic_game_object_4.in_state?(@mock_state_1).should be_true
end

Then /^I expect the state to be reverted$/ do
  @basic_game_object_4.current_state.should be @mock_state_instance_1
  @basic_game_object_4.previous_state.should be @mock_state_instance_2
end

Given /^an instance of BasicGameObject 4$/ do
  @basic_game_object_5 = BasicGameObject.new
  @basic_game_object_5.should_not be_nil
  @basic_game_object_5.should be_an_instance_of BasicGameObject
end

When /^I mock a global state$/ do
  @mock_global_state = mock
  @mock_global_state_instance = mock

  @mock_global_state.expects(:instance).returns(@mock_global_state_instance)
  @mock_global_state_instance.expects(:execute).with(@basic_game_object_5)
end

When /^I assign the global state to the game object$/ do
  @basic_game_object_5.global_state = @mock_global_state
end

Then /^I expect the state change to take place$/ do
  @basic_game_object_5.update
  @basic_game_object_5.global_state.should be @mock_global_state_instance
end