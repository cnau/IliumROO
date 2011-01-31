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
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"
require "game_objects/game_object_loader"
require "game/objects/basic_persistent_game_object"

Given /^a mocked persistent class$/ do
  obj_hash = {'game_object_id'=> 'persistent_class_1',
              'super'         => 'BasicPersistentGameObject',
              'properties'    => 'foo,bar,foo_text'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('persistent_class_1').returns(obj_hash)
end

When /^I request the persistent class$/ do
  @persistent_obj_c_1 = GameObjectLoader.load_object 'persistent_class_1'
  @persistent_obj_c_1.nil?.should == false
end

Then /^I get the correct class object$/ do
  @persistent_obj_c_1.superclass.should == BasicPersistentGameObject
  @persistent_obj_c_1.properties.include?(:foo).should == true
  @persistent_obj_c_1.properties.include?(:bar).should == true
  @persistent_obj_c_1.properties.include?(:foo_text).should == true
end

Given /^a mocked persistent object$/ do
  obj_hash = {'game_object_id'  => 'persistent_object_1',
              'parent'          => 'persistent_class_1',
              'foo'             => '1',
              'bar'             => '2',
              'foo_text'        => 'some text'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('persistent_object_1').once.returns(obj_hash)
end

When /^I request a new persistent object$/ do
  @persistent_obj_1 = GameObjectLoader.load_object 'persistent_object_1'
  @persistent_obj_1.nil?.should == false
end

Then /^I get the correct persistent object$/ do
  @persistent_obj_1.is_a?(BasicPersistentGameObject).should == true
  obj_hash = @persistent_obj_1.to_hash
  puts obj_hash.inspect

  obj_hash.has_key?('game_object_id').should == true
  obj_hash['game_object_id'].should == "persistent_object_1"

  obj_hash.has_key?('foo').should == true
  obj_hash['foo'].should == "1"

  obj_hash.has_key?('bar').should == true
  obj_hash['bar'].should == "2"

  obj_hash.has_key?('foo_text').should == true
  obj_hash['foo_text'].should == "some text"

  obj_hash.has_key?('parent').should == true
  obj_hash['parent'].should == "persistent_class_1"
end

Given /^a mocked persistent object to save$/ do
  obj_hash = {'game_object_id'  => 'persistent_object_2',
              'parent'          => 'persistent_class_1',
              'foo'             => '1',
              'bar'             => '2',
              'foo_text'        => 'some text'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('persistent_object_2').once.returns(obj_hash)
end

Given /^a mocked save database function$/ do
  GameObjects.expects(:save).with('persistent_object_2', {'foo' => '1', 'bar' => '2', 'foo_text' => 'some text', 'parent' => 'persistent_class_1', 'owner' => '', 'group' => '', 'mode' => '493', 'game_object_id' => 'persistent_object_2'}).once
end

When /^I load a persistent object instance$/ do
  @persistent_obj_2 = GameObjectLoader.load_object 'persistent_object_2'
  @persistent_obj_2.nil?.should == false
  @persistent_obj_2.is_a?(BasicPersistentGameObject).should == true
end

When /^I save a persistent object instance$/ do
  @persistent_obj_2.save
end

Then /^the object should save$/ do
  #NOOP: mocha should fail here if save expectation isn't met
end

Given /^a mocked persistent class 2$/ do
  obj_hash = {'game_object_id'=> 'persistent_class_2',
              'super'         => 'BasicPersistentGameObject',
              'properties'    => 'foo,bar,foo_text'}

  GameObjects.expects(:get).with('persistent_class_2').returns(obj_hash)
end

Given /^a mocked save function 2$/ do
  GameObjects.expects(:save).with(@persistent_obj_3.game_object_id, {'foo' => '5', 'bar' => '6', 'foo_text' => '', 'parent' => 'persistent_class_2', 'owner' => '', 'group' => '', 'mode' => '493', 'game_object_id' => @persistent_obj_3.game_object_id}).once
end

When /^I load a persistent class 2$/ do
  @persistent_obj_c_2 = GameObjectLoader.load_object 'persistent_class_2'
  @persistent_obj_c_2.nil?.should == false
  @persistent_obj_c_2.is_a?(Class).should == true
end

When /^I create an object instance from persistent class 2$/ do
  @persistent_obj_3 = @persistent_obj_c_2.new
  @persistent_obj_3.nil?.should == false
  @persistent_obj_3.is_a?(@persistent_obj_c_2).should == true
end

When /^I change some properties in persistent object$/ do
  @persistent_obj_3.foo = 5
  @persistent_obj_3.bar = 6
end

When /^I save the persistent object 2$/ do
  @persistent_obj_3.save
end

Then /^the object should save 2$/ do
end