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
require 'logging/logging'
require 'minitest/autorun'
require 'database/game_objects'
require 'database/cassandra_dao'

# database unit tests
class TestGameObjects < MiniTest::Unit::TestCase
  include Logging

  def test_basic_objects
    object_id = 'test_object_id_1'
    object_hash = {'object_id' => object_id, 'name' => 'name'}

    GameObjects.remove object_id

    obj = GameObjects.get object_id
    assert_equal 0, obj.length, "make sure this object id doesn't already exist"

    GameObjects.save object_id, object_hash
    obj = GameObjects.get object_id
    assert_equal 2, obj.length, 'make sure object was inserted'
    assert_equal object_id, obj['object_id'], 'make sure the correct object hash was retrieved'
    assert_equal 'name', obj['name'], 'make sure the correct object has was retrieved'

    GameObjects.remove object_id
    obj = GameObjects.get object_id
    assert_equal 0, obj.length, 'make sure this object id was removed'

    obj_hash = {'object_id'  => object_id,
                'super'      => 'BasicObject.rb',
                'properties' => 'foo,bar',
                'foo_bar'    => 'foo + bar'}

    GameObjects.save object_id, obj_hash
    obj = GameObjects.get object_id
    assert_equal obj_hash, obj, 'make sure returned hash is identical'
    GameObjects.remove object_id
  end

  def test_object_tags
    object_id_1 = 'test_object_id_1'
    object_name_1 = 'test_name_1'

    object_id_2 = 'test_object_id_2'
    object_name_2 = 'test_name_2'

    GameObjects.remove_tag 'player_names', object_name_1
    GameObjects.remove_tag 'player_names', object_name_2

    obj = GameObjects.get_tag 'player_names', object_name_1
    assert_equal 0, obj.length

    obj = GameObjects.get_tag 'player_names', object_name_2
    assert_equal 0, obj.length

    GameObjects.add_tag 'player_names', object_name_1, {'object_id' => object_id_1}
    obj = GameObjects.get_tag 'player_names', object_name_1
    assert_equal 1, obj.length

    GameObjects.add_tag 'player_names', object_name_2, {'object_id' => object_id_2}
    obj = GameObjects.get_tag 'player_names', object_name_2
    assert_equal 1, obj.length

    GameObjects.remove_tag 'player_names', object_name_1
    obj = GameObjects.get_tag 'player_names', object_name_1
    assert_equal 0, obj.length

    GameObjects.remove_tag 'player_names', object_name_2
    obj = GameObjects.get_tag 'player_names', object_name_2
    assert_equal 0, obj.length
  end
end