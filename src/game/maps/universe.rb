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

class Universe < BasicPersistentGameObject
  include Logging
  
  PROPERTIES = [:name].freeze

  attr_accessor :name

  def initialize
    super
    @name ||= "Universe"
    log.level = Logger::DEBUG
  end

  def save
    super
    GameObjects.add_tag 'maps', self.name, {'object_id' => self.game_object_id}
  end

  def let_there_be_light
    log.debug "and there was light"
  end
end