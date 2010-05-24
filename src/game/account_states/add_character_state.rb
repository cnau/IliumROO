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

class AddCharacterState
  include Singleton
  include Colorizer

  def enter(entity)
    entity.send_to_client "Enter new character's name:"
  end

  def exit(entity)
  end

  def execute(entity)
    name = entity.last_client_data.capitalize
    if name.empty?
      entity.change_state MainMenuState 
    elsif name.match(/^[A-Z][a-z]*$/)
      if PlayerCharacter.name_available? name
        entity.add_new_character name
        entity.send_to_client "Added new character named #{name}.\n"
        entity.change_state MainMenuState
      else
        entity.send_to_client "That name is already taken.\n"
        entity.change_state AddCharacterState
      end
    else
      entity.send_to_client "Invalid character name.  Name should start with a capital letter.\n"
      entity.change_state AddCharacterState
    end
  end
end