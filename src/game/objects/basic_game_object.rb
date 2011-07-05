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

require 'game/objects/mixins/state_machine'
require 'game/objects/mixins/client_wrapper'
require 'game/objects/mixins/command_arguments'
require 'logging/logging'
require 'simple_uuid'

class BasicGameObject
  include SimpleUUID
  include StateMachine
  include ClientWrapper
  include Logging
  include CommandArguments

  @game_object_id = nil

  def game_object_id
    @game_object_id ||= UUID.new.to_guid.to_s
    @game_object_id
  end

  def game_object_id=(val)
    # one time setter
    @game_object_id = val if @game_object_id.nil?
  end

  # to add additional persisted fields, simply add this constant to your classes that inherit from BasicGameObject.
  # then add symbols for each property you want to persist.  Classes built using the GameObjectLoader will
  # generate this property for child classes automatically based on the "properties" tag in the database.

  # master properties indicates this object is a "template" object and is read-only
  PROPERTIES = [:game_object_id].freeze

  def self.properties
    @properties ||= []
    if @properties.empty?
      self.ancestors.each do |ancestor|
        @properties += ancestor::PROPERTIES if ancestor.const_defined? "PROPERTIES"
      end
    end
    @properties
  end

  def self.verbs
    @verbs ||= {}
    if @verbs.empty?
      self.ancestors.each do |ancestor|
        @verbs.merge! ancestor::VERBS if ancestor.const_defined? "VERBS"
      end
    end
    @verbs
  end

  def on_load
    log.debug "loaded game object #{@game_object_id}"
  end

  def to_hash
    @game_object_id ||= UUID.new.to_guid.to_s
    ret = {}
    self.class.properties.each do |prop|
      ret[prop.to_sym] = self.instance_variable_get("@#{prop}").to_s
    end
    ret
  end
end