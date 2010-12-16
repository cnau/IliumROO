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

require 'game/utils/state_machine'
require 'game/objects/mixins/client_wrapper'
require 'game/login_states/start_login_state'

class LoginWrapper
  include StateMachine
  include ClientWrapper

  attr_accessor :account, :email_address, :ctr

  def do_login
    @ctr = 0
    change_state StartLoginState
  end
end