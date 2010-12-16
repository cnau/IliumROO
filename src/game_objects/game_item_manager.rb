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

require 'game_objects/game_object_loader'
require 'logging/logging'
include Logging

module GameItemManager
  def register_game_item(game_item)
    if game_item.master
      unless game_item.name.nil?
        Logging::log.debug {"adding tag for #{game_item.name}"}
        GameObjects.add_tag game_item.object_tag.to_s, game_item.name, {'object_id' => game_item.game_object_id}
      end

      unless game_item.alias.nil?
        game_item.alias.split(" ").each do |an_alias|
          Logging::log.debug {"adding tag for #{an_alias}"}
          GameObjects.add_tag game_item.object_tag.to_s, an_alias, {'object_id' => game_item.game_object_id}
        end
      end
    end
  end

  def unregister_game_item(game_item)
    if game_item.master
      unless game_item.name.nil?
        Logging::log.debug {"removing tag for #{game_item.name}"}
        GameObjects.remove_tag game_item.object_tag.to_s, game_item.name
      end

      unless game_item.alias.nil?
        game_item.alias.split(" ").each do |an_alias|
          Logging::log.debug {"removing tag for #{an_alias}"}
          GameObjects.remove_tag game_item.object_tag.to_s, an_alias
        end
      end
    end
  end

  def recycle_game_item(game_item)
    unregister_game_item game_item
    GameObjects.add_tag 'recycled', self.name, {'object_id' => self.game_object_id}
  end

  module_function :register_game_item, :unregister_game_item, :recycle_game_item
end