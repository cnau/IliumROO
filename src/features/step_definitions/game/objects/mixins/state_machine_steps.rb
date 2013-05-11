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

# a test class that mixes in the state machine module
class BasicEntity
  attr_accessor :entering_class, :exiting_class, :executing_class
  def on_enter(state_class)
    @entering_class = state_class
  end
  def on_exit(state_class)
    @exiting_class = state_class
  end
  def on_execute(state_class)
    @executing_class = state_class
  end
end

class BasicState
  include Singleton

  def enter(entity)
    entity.entity.on_enter self
  end

  def exit(entity)
    entity.entity.on_exit self
  end

  def execute(entity)
    entity.entity.on_execute self
  end
end

class BasicStateFirst < BasicState
end

class BasicStateSecond < BasicState
end

class BasicStateMachine
  include StateMachine
  attr_accessor :entity
  
  def set_entity(entity)
    @entity = entity
  end
end

Given /^a new basic state machine object 1$/ do
  @state_machine_1 = BasicStateMachine.new
  @state_machine_1.should_not be_nil
end

Given /^a new entity object 1$/ do
  @client_entity_1 = BasicEntity.new
  @client_entity_1.should_not be_nil
  @state_machine_1.set_entity @client_entity_1
end

When /^I set the global state 1$/ do
  @state_machine_1.global_state = BasicState
end

When /^I update state 1$/ do
  @state_machine_1.update
end

Then /^the global state should be set properly$/ do
  @state_machine_1.global_state.should equal BasicState.instance
  @client_entity_1.entering_class.should be_nil
  @client_entity_1.exiting_class.should be_nil
  @client_entity_1.executing_class.should equal BasicState.instance
end

Given /^a new basic state machine object 2$/ do
  @state_machine_2 = BasicStateMachine.new
  @state_machine_2.should_not be_nil
end

Given /^a new entity object 2$/ do
  @client_entity_2 = BasicEntity.new
  @client_entity_2.should_not be_nil
  @state_machine_2.set_entity @client_entity_2
end

When /^I change state 2$/ do
  @state_machine_2.change_state BasicState
  @state_machine_2.in_state?(BasicState).should be_true
end

Then /^I should see the correct state transition 2$/ do
  @client_entity_2.entering_class.should equal BasicState.instance
  @client_entity_2.exiting_class.should be_nil
  @client_entity_2.executing_class.should be_nil
end

Given /^a new basic state machine object 3$/ do
  @state_machine_3 = BasicStateMachine.new
  @state_machine_3.should_not be_nil
end

Given /^a new entity object 3$/ do
  @client_entity_3 = BasicEntity.new
  @client_entity_3.should_not be_nil
  @state_machine_3.set_entity @client_entity_3
end

When /^I change state 3$/ do
  @state_machine_3.change_state BasicState
  @state_machine_3.in_state?(BasicState).should be_true
end

When /^I update state 3$/ do
  @state_machine_3.update
end

Then /^I should see the correct state transition 3$/ do
  @client_entity_3.entering_class.should equal BasicState.instance
  @client_entity_3.executing_class.should equal BasicState.instance
  @client_entity_3.exiting_class.should be_nil
end

Given /^a new basic state machine object 4$/ do
  @state_machine_4 = BasicStateMachine.new
  @state_machine_4.should_not be_nil
end

Given /^a new entity object 4$/ do
  @client_entity_4 = BasicEntity.new
  @client_entity_4.should_not be_nil
  @state_machine_4.set_entity @client_entity_4
end

When /^I set the initial state$/ do
  @state_machine_4.change_state BasicStateFirst
  @state_machine_4.in_state?(BasicStateFirst).should be_true
  @client_entity_4.entering_class.should equal BasicStateFirst.instance
  @client_entity_4.exiting_class.should be_nil
  @client_entity_4.executing_class.should be_nil
end

When /^I change state 4$/ do
  @state_machine_4.change_state BasicStateSecond
  @state_machine_4.in_state?(BasicStateSecond).should be_true
end

When /^I update state 4$/ do
  @state_machine_4.update
end

Then /^I should see the correct state transition 4$/ do
  @client_entity_4.entering_class.should equal BasicStateSecond.instance
  @client_entity_4.exiting_class.should equal BasicStateFirst.instance
  @client_entity_4.executing_class.should equal BasicStateSecond.instance
end

When /^I revert to the previous state$/ do
  @state_machine_4.revert_to_previous_state
  @state_machine_4.in_state?(BasicStateFirst).should be_true
end

Then /^I should see the correct revert state transition$/ do
  @client_entity_4.entering_class.should equal BasicStateFirst.instance
  @client_entity_4.exiting_class.should equal BasicStateSecond.instance
end

