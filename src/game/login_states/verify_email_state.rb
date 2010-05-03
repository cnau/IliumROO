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

class VerifyEmailState
  include Singleton

  def enter(entity)
    entity.send_to_client "#{entity.email_address}, did I get that right?"
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.match(/^[y](?:es)?$/i)
      entity.change_state StartSignupState.instance
    else
      entity.revert_to_previous_state
    end
  end
end