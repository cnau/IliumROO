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

require 'logging/logging'
require 'database/game_objects'
require 'game_objects/basic_persistent_game_object'

class ClientAccount < BasicPersistentGameObject
  include Logging

  PROPERTIES = [:email, :password, :last_login_date, :last_login_ip, :display_type].freeze

  attr_accessor :email, :password, :last_login_date, :last_login_ip, :display_type

  def initialize
    super
    @display_type ||= "ANSI"
  end

  def save
    super
    GameObjects.add_tag 'accounts', self.email, {'object_id' => self.game_object_id}
  end
end