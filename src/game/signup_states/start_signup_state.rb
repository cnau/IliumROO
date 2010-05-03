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
require 'database/game_objects'
require 'game/signup_states/start_signup_state'
require 'game/account_states/main_menu_state'
require 'game_objects/client_account'
require 'game/utils/password'
require 'date'

class StartSignupState  
  include Singleton

  def enter(entity)
    entity.send_to_client "Give me a password for #{entity.email_address}:"
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.length == 0
      entity.send_to_client "Invalid password.  Please try again."
      entity.change_state self
    else
      client_account = ClientAccount.new
      client_account.password = Password::update(entity.last_client_data)
      client_account.email = entity.email_address
      client_account.last_login_ip = entity.client.client_ip
      client_account.last_login_date = DateTime.now.strftime
      client_account.save
      client_account.attach_client entity.client
      entity.detach_client
      client_account.change_state MainMenuState.instance
    end
  end
end