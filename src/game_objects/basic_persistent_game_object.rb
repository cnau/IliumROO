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

require 'game_objects/basic_game_object'

class BasicPersistentGameObject < BasicGameObject
  PROPERTIES = [].freeze

  def save
    obj_hash = self.to_hash
    obj_id = obj_hash[:game_object_id]
    GameObjects.save(obj_id, obj_hash) unless obj_id.nil?
  end
end