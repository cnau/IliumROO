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
require 'game/account_states/main_menu_state'
require 'game_objects/player_character'

class DeleteCharacterState
  include Singleton
  include Colorizer

  def enter(entity)
    entity.change_state MainMenuState.instance if entity.characters.empty?

    del_menu = ""
    ctr = 1
    c_list = entity.characters.split(",")
    c_list.each do |character_id|
      character_name = PlayerCharacter.get_player_name(character_id)
      del_menu << "[blue]#{ctr}.[white] #{character_name}\n"
      ctr += 1
    end

    del_menu = colorize(del_menu, entity.display_type)
    entity.send_to_client del_menu << "Choose a character to delete: "
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.empty?
      entity.change_state MainMenuState.instance
    else
      c_idx = entity.last_client_data.to_i
      c_list = entity.characters.split(",")
      if (c_idx >= 1) and (c_idx <= c_list.length)
        entity.remove_character c_list[c_idx - 1]
        c_name = PlayerCharacter.get_player_name(c_list[c_idx - 1])
        PlayerCharacter.delete_character c_list[c_idx - 1]
        entity.send_to_client "Deleted #{c_name}.\n"
        entity.change_state MainMenuState.instance
      else
        entity.change_state DeleteCharacterState.instance
      end
    end
  end
end