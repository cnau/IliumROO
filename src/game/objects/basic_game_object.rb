=begin
Copyright (c) 2009-2012 Christian Nau

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

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