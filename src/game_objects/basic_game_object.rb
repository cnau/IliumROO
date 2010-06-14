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
require 'game/utils/client_wrapper'

class BasicGameObject
  include StateMachine
  include ClientWrapper
  
  @game_object_id = nil

  def game_object_id
    @game_object_id ||= BasicGameObject.generate_game_object_id
    @game_object_id
  end

  def game_object_id=(val)
    # one time setter
    @game_object_id = val if @game_object_id.nil?
  end
  
  # to add additional persisted fields, simply add this constant to your classes that inherit from BasicGameObject.
  # then add symbols for each property you want to persist.  Classes built using the GameObjectLoader will
  # generate this property for child classes automatically based on the "properties" tag in the database.
  PROPERTIES = [:game_object_id].freeze

  def self.generate_game_object_id
    #verify game object id is unique
    start_range = 0x10000000
    end_range   = 0xFFFFFFFF
    dup_obj = {}
    begin
      new_obj_id = (start_range + rand(end_range - start_range + 1)).to_s(16)     # generate hex game object id
      dup_obj = GameObjects.get new_obj_id
    end until dup_obj.empty?
    new_obj_id
  end

  def self.properties
    ret = []
    self.ancestors.each do |ancestor|
      ret += ancestor::PROPERTIES if ancestor.const_defined? "PROPERTIES"
    end
    ret
  end

  def self.verbs
    ret = {}
    self.ancestors.each do |ancestor|
      ret.merge! ancestor::VERBS if ancestor.const_defined? "VERBS"
    end
    ret
  end

  def to_hash
    @game_object_id ||= BasicGameObject.generate_game_object_id
    ret = {}
    self.class.properties.each do |prop|
      ret[prop] = self.instance_variable_get("@#{prop}").to_s
    end
    ret
  end
end