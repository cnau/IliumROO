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
require 'game/account_states/view_account_details_state'

class ListAccountsState
  include Singleton
  include Colorizer

  def enter(entity)
    accounts = GameObjects.get_tags "accounts"

    if accounts.empty?
      entity.change_state MainMenuState
      return
    end

    menu = ""
    ctr = 1
    accounts.each do |account_name, account_hash|
      menu << "[blue]#{ctr}.[white] #{account_name}\n"
      ctr += 1
    end

    menu = colorize(menu, entity.display_type)
    entity.send_to_client menu << "Choose account (q): "
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.empty?
      entity.change_state MainMenuState
    else
      accounts = GameObjects.get_tags "accounts"
      idx = entity.last_client_data.to_i
      if idx > 0 and idx <= accounts.count
        entity.change_state ViewAccountDetailsState
      else
        entity.change_state ListAccountsState
      end
    end
  end
end