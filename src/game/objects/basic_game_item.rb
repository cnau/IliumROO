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

require 'database/game_objects'
require 'game/objects/basic_persistent_game_object'

class BasicGameItem < BasicPersistentGameObject
  PROPERTIES = [:name, :alias, :master].freeze
  attr_accessor :name, :alias, :master

  VERBS = {'recycle' => nil}.freeze

  def save
    super
    if self.master
      @log.debug {"adding tag for #{self.name}"}
      GameObjects.add_tag 'items', self.name, {'object_id' => self.game_object_id}

      self.alias.split(" ").each do |an_alias|
        @log.debug {"adding tag for #{an_alias}"}
        GameObjects.add_tag 'items', an_alias, {'object_id' => self.game_object_id}
      end
    end
  end

  def recycle
    if self.master
      @log.debug {"removing tag for #{self.name}"}
      GameObjects.remove_tag 'items', self.name

      self.alias.split(" ").each do |an_alias|
        @log.debug {"removing tag for #{an_alias}"}
        GameObjects.remove_tag 'items', an_alias
      end
    end

    GameObjects.add_tag 'recycled', self.name, {'object_id' => self.game_object_id}
    @player.send_to_client "#{self.name} has been recycled."
  end
end