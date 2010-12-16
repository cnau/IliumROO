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

require 'game/objects/basic_persistent_game_object'
require 'game_objects/game_item_manager'

class BasicNamedObject < BasicPersistentGameObject
  PROPERTIES = [:name, :alias, :object_tag].freeze
  attr_accessor :name, :alias, :object_tag

  VERBS = {:recycle => nil}.freeze

  def save
    super
    GameItemManager::register_game_item self
    send_to_client "#{self.name} saved."
  end

  def recycle
    send_to_client "#{self.name} has been recycled."
    GameItemManager::recycle_game_item self
  end
end