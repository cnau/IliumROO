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

require 'features/step_definitions/spec_helper.rb'
require 'database/game_objects'
require 'game_objects/game_object_loader'
require 'game/objects/basic_game_object'
require 'mocha'

Given /^a mock class setup$/ do
  obj_hash = {'game_object_id'=> 'test_class_1',
              'super'         => 'BasicGameObject',
              'mixins'        => 'Logging',
              'properties'    => 'game_object_id,foo,bar,foo_text,foo_obj',
              'foo_bar'       => 'self.foo + self.bar',
              'foo_log'       => 'log.info "some info"',
              'foo_m(param)'  => 'log.info param'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('test_class_1').returns(obj_hash)
end

When /^I load test class object$/ do
  @obj_c = GameObjectLoader.load_object 'test_class_1'
  @obj_c.should_not be_nil
end

Then /^I verify class structure$/ do
  @obj_c.superclass.name.should eql 'BasicGameObject'
  @obj_c.public_instance_methods.should include :foo
  @obj_c.public_instance_methods.should include :bar
  @obj_c.public_instance_methods.should include :game_object_id
  @obj_c.public_instance_methods.should include :foo_bar
  @obj_c.public_instance_methods.should include :foo_log
  @obj_c.public_instance_methods.should include :foo_obj
  @obj_c.included_modules.should include Logging
end

And /^a mock object setup$/ do
  obj_hash = {'game_object_id'  => 'test_object_1',
              'parent'          => 'test_class_1',
              'foo'             => '1',
              'bar'             => '2',
              'foo_text'        => 'some text',
              'foo_obj'         => '$${BasicGameObject}.new'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('test_object_1').returns(obj_hash)
end

And /^I load test object$/ do
  @obj = GameObjectLoader.load_object 'test_object_1'
  @obj.should_not be_nil
end

Then /^I verify object structure$/ do
  @obj.game_object_id.should eql 'test_object_1'
  @obj.should be_an_instance_of @obj_c
  @obj.foo.should eql 1
  @obj.bar.should eql 2
  @obj.foo_bar.should eql 3
  @obj.foo_text.should eql 'some text'
  @obj.foo_obj.should be_an_instance_of BasicGameObject
end