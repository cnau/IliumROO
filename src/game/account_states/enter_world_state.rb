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

require 'singleton'
require 'game/utils/colorizer'
require 'game_objects/player_character'
require 'game_objects/game_object_loader'

class EnterWorldState
  include Singleton
  include Colorizer

  def enter(entity)
    if entity.characters.nil?
      entity.change_state MainMenuState
      return
    end

    enter_menu = ""
    ctr = 1
    c_list = entity.characters.split(",")
    c_list.each do |character_id|
      character_name = PlayerCharacter.get_player_name(character_id)
      enter_menu << "[blue]#{ctr}.[white] #{character_name}\n"
      ctr += 1
    end

    enter_menu = colorize(enter_menu, entity.display_type)
    entity.send_to_client enter_menu << "Choose a character to play: "
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.empty?
      entity.change_state MainMenuState
    else
      c_idx = entity.last_client_data.to_i
      c_list = entity.characters.split(",")
      if (c_idx >= 1) and (c_idx <= c_list.length)

      else
        entity.change_state EnterWorldState
      end
    end
  end
end