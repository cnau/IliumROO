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

class ViewAccountDetailsState
  include Singleton
  include Colorizer

  def enter(entity)
    accounts = GameObjects.get_tags "accounts"

    if accounts.empty?
      entity.change_state MainMenuState
      return
    end

    idx = entity.last_client_data.to_i
    if idx <= 0 or idx > accounts.length
      entity.change_state MainMenuState
      return
    end

    ctr = 1
    accounts.each do |account_name,account_hash|
      if ctr == idx
        account = ClientAccount.get_account account_hash['object_id']
        menu = "Account name: #{account.email}\n"
        menu << "Last login date: #{account.last_login_date}\n"
        menu << "Last login IP: #{account.last_login_ip}\n"
        menu << "Display type: #{account.display_type}\n"
        menu << "Account type: #{account.account_type}\n"
        menu << "Press enter when done:"
        menu = colorize(menu, entity.display_type)
        entity.send_to_client menu
        return
      end
      ctr += 1
    end
  end

  def exit(entity)
  end

  def execute(entity)
    entity.change_state MainMenuState
  end
end