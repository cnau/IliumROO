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
require 'game/login_states/verify_email_state'
require 'game/login_states/get_password_state'

class StartLoginState
  include Singleton

  def enter(entity)
    entity.email_address = nil
    entity.send_to_client "Email Address:"
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.match(/^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i)
      entity.email_address = entity.last_client_data
      account = GameObjects.get_tag 'accounts', entity.email_address 

      if account.empty? 
        entity.change_state VerifyEmailState.instance
      else
        entity.account = account
        entity.change_state GetPasswordState.instance
      end
    else
      entity.send_to_client "invalid email\n"
      entity.change_state self
    end
  end
end