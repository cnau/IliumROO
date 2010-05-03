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

require 'game/game'
require 'game_objects/game_object_loader'
require 'database/game_objects'

game = nil

# get the game_object_id for the game object
game_info = GameObjects.get_tag 'startup', 'game'

if game_info.empty?
  # create the game
  game = Game.new
  game.port_list = "6666"
  game.save
else
  # load the game
  game = GameObjectLoader.load_object game_info['object_id']
end

game.start