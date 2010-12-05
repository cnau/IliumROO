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

require 'logging/logging'
require 'minitest/autorun'
require 'database/game_objects'
require 'game_objects/game_object_loader'
require 'game/objects/basic_game_object'
require 'mocha'

class TestGameObjectLoader < MiniTest::Unit::TestCase
  include Logging

  def test_load_by_object_hash
    log.debug 'testing load by object hash'
    obj_hash = {'game_object_id'=> 'test_class_1',
                'super'         => 'BasicGameObject',
                'mixins'        => 'Logging',
                'properties'    => 'game_object_id,foo,bar,foo_text,foo_obj',
                'foo_bar'       => 'self.foo + self.bar',
                'foo_log'       => 'log.info "some info"',
                'foo_m(param)'  => 'log.info param'}

    # setup mock game object to prevent database hit
    GameObjects.expects(:get).with('test_class_1').once.returns(obj_hash)

    obj_c = GameObjectLoader.load_object 'test_class_1'
    refute_nil obj_c

    assert_equal 'BasicGameObject', obj_c.superclass.name, "make sure #{obj_c} is derived from BasicGameObject"
    assert obj_c.public_instance_methods.include?(:foo), "make sure new class contains foo method"
    assert obj_c.public_instance_methods.include?(:bar), "make sure new class contains bar method"
    assert obj_c.public_instance_methods.include?(:game_object_id), "make sure new class contains game_object_id method"
    assert obj_c.public_instance_methods.include?(:foo_bar), "make sure new class contains foo_bar method"
    assert obj_c.public_instance_methods.include?(:foo_log), "make sure new class contains foo_log method"
    assert obj_c.public_instance_methods.include?(:foo_obj), "make sure new class contains foo_obj method"
    assert obj_c.included_modules.include?(Logging), "make sure logging mixin was included in class"

    obj_hash = {'game_object_id'  => 'test_object_1',
                'parent'          => 'test_class_1',
                'foo'             => '1',
                'bar'             => '2',
                'foo_text'        => 'some text',
                'foo_obj'         => '$${BasicGameObject}.new'}

    # setup mock game object to prevent database hit
    GameObjects.expects(:get).with('test_object_1').once.returns(obj_hash)
    
    obj = GameObjectLoader.load_object 'test_object_1'
    assert_equal 'test_object_1', obj.game_object_id
    assert obj.is_a?(obj_c), "make sure #{obj} is a #{obj_c}"
    assert_equal 1, obj.foo, "make sure obj.foo = 1"
    assert_equal 2, obj.bar, "make sure obj.bar = 2"
    assert_equal 3, obj.foo_bar, "make sure foo + bar = 3"
    assert_equal 'some text', obj.foo_text, "make sure text value was set properly"
    assert obj.foo_obj.is_a?(BasicGameObject), "make sure foo_obj is a BasicGameObject"
  end
end