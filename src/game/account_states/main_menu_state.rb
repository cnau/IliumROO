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
require 'game/client_master'
require 'game/account_states/logout_state'
require 'game/account_states/add_character_state'
require 'game/account_states/delete_character_state'
require 'game/account_states/display_options_state'
require 'game/account_states/enter_world_state'

class MainMenuState
  include Singleton
  include Colorizer

  def enter(entity)
    # build main menu string
    main_menu = ""
    main_menu << "[blue]1.[white] enter world\n"
    main_menu << "[blue]2.[white] add character\n"
    main_menu << "[blue]3.[white] delete character\n"
    main_menu << "[blue]4.[white] set display options\n"
    main_menu << "[blue]5.[white] quit\n"
    main_menu << "[white]choose and perish:"
    main_menu = colorize(main_menu, entity.display_type)

    entity.send_to_client main_menu
  end

  def exit(entity)
  end

  def execute(entity)
    case entity.last_client_data
      when '1' then
        entity.change_state EnterWorldState
        
      when '2' then
        entity.change_state AddCharacterState

      when '3' then
        entity.change_state DeleteCharacterState

      when '4' then
        entity.change_state DisplayOptionsState

      when '5' then
        entity.change_state LogoutState

      else
        entity.send_to_client "invalid option\n"
        entity.change_state MainMenuState
    end
  end
end