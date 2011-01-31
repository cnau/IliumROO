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
  @obj_c.nil?.should == false
end

Then /^I verify class structure$/ do
  @obj_c.superclass.name.should == 'BasicGameObject'
  @obj_c.public_instance_methods.include?(:foo).should == true
  @obj_c.public_instance_methods.include?(:bar).should == true
  @obj_c.public_instance_methods.include?(:game_object_id).should == true
  @obj_c.public_instance_methods.include?(:foo_bar).should == true
  @obj_c.public_instance_methods.include?(:foo_log).should == true
  @obj_c.public_instance_methods.include?(:foo_obj).should == true
  @obj_c.included_modules.include?(Logging).should == true
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
  @obj.nil?.should == false
end

Then /^I verify object structure$/ do
  @obj.game_object_id.should == 'test_object_1'
  @obj.is_a?(@obj_c).should == true
  @obj.foo.should == 1
  @obj.bar.should == 2
  @obj.foo_bar.should == 3
  @obj.foo_text.should == 'some text'
  @obj.foo_obj.is_a?(BasicGameObject).should == true
end