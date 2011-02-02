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

require 'game/objects/basic_owned_object'

class BasicPersistentGameObject < BasicOwnedObject
  PROPERTIES = [:parent].freeze
  attr_accessor :parent
  
  VERBS = {:save => nil, :recycle => nil}.freeze

  def initialize
    super
    matches = self.class.name.match(/Kernel::C(.*)/)
    if matches
      @parent = matches[1]
    else
      @parent = self.class.name
    end
  end

  def save(args = nil)
    obj_hash = self.to_hash
    log.debug "saving hash #{obj_hash}"
    obj_id = obj_hash['game_object_id']
    GameObjects.save(obj_id, obj_hash) unless obj_id.nil?
  end

  def recycle(args = nil)
    if self.class.properties.include? :name then
      obj_name = self.name
    else
      obj_name = self.game_object_id
    end
    GameObjects.add_tag 'recycled', obj_name, {'object_id' => self.game_object_id}
  end
end