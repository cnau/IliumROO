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

require 'database/game_objects'
require 'game_objects/game_object_loader'
require 'game_objects/basic_persistent_game_object'

class PlayerCharacter < BasicPersistentGameObject
  PROPERTIES = [:name, :owner, :map, :location].freeze

  attr_accessor :name, :owner, :map, :location

  def save
    super
    GameObjects.add_tag 'player_names', self.name, {'object_id' => self.game_object_id}
  end

  def self.name_available?(the_name)
    player_name = GameObjects.get_tag 'player_names', the_name
    return true if player_name.empty?
    return false
  end

  def self.get_player_name(game_object_id)
    player_hash = GameObjects.get game_object_id
    player_hash['name']
  end

  def self.delete_character(game_object_id)
    c_name = PlayerCharacter.get_player_name game_object_id
    GameObjects.remove game_object_id
    GameObjectLoader.remove_from_cache game_object_id
    GameObjects.remove_tag 'player_names', c_name
  end
end