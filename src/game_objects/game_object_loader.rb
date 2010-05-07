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
require 'logging/logging'
require 'database/game_objects'
require 'game_objects/basic_game_object'

# loads game objects and caches them
class GameObjectLoader
  include Singleton
  include Logging

  def initialize
    @cache ||= {}
  end

  # loads game objects and stores them in cache
  # [object_id] the object id to load
  # [object_hash] the hash describing the object
  def load_object(object_id)
    return nil if object_id.nil?

    new_o = load_object_by_id(object_id)

    if !new_o.nil?
      log.debug {"caching object #{new_o} as #{object_id}" }
      @cache[object_id] = new_o
    end

    return new_o
  end

  # loads game objects and stores them in cache
  # [object_id] the object id to load
  # [object_hash] the hash describing the object
  def self.load_object(object_id)
    GameObjectLoader.instance.load_object object_id
  end

  def load_object_by_id(object_id)
    # look for object in cache
    log.debug {"found #{object_id} in #{@cache}"} if @cache.has_key? object_id
    return @cache[object_id] if @cache.has_key? object_id

    # load the object from the database
    log.debug {"loading game object #{object_id} from database"}
    obj_hash = GameObjects.get object_id
    log.debug {"found game object #{obj_hash}"}
    return nil if obj_hash.nil? or obj_hash.empty?
    
    # build the object
    log.debug {"building object by hash #{obj_hash}"}
    new_o = build_object_by_hash obj_hash
    return new_o
  end

  def load_class_by_id(object_id)
    # look for class in Kernel
    # only check Kernel if the class name is properly capitalized
    if object_id.match(/^[A-Z][A-Za-z0-9_]*$/)
      if Kernel.const_defined? object_id
        log.debug {"found #{object_id} in Kernel object"}
        return Kernel.const_get object_id
      elsif Object.const_defined? object_id
        log.debug {"found #{object_id} in Object object"}
        return Object.const_get object_id
      end
    end

    # not a pre made class so load the object
    return load_object_by_id object_id
  end

  def setup_class_by_hash(object_hash)
    # get the object's super class
    log.debug {"getting super class for #{object_hash}"}
    super_c = load_class_by_id(object_hash['super'])
    super_c = BasicGameObject if super_c.nil?
    log.debug {"found super class #{super_c}"}

    # create a new class derived from the super class
    log.debug {"building class #{object_hash} derived from #{super_c}"}
    new_c = Class.new super_c
    log.debug {"setting kernel class name C#{object_hash['game_object_id']} to #{new_c}"}
    Kernel.const_set "C#{object_hash['game_object_id']}", new_c
    log.debug {"built class #{new_c}"}
    
    # add properties to the class
    prop_array = ""
    object_hash['properties'].split(',').map do |prop|
      #TODO:make this next part sandbox safe
      unless new_c.public_instance_methods.include?(eval(":#{prop}"))
        log.debug {"adding property #{prop} to #{new_c}"}
        new_c.class_eval "def #{prop};@#{prop};end;def #{prop}=(val);@#{prop} = val;end;"
      end
      prop_array += "," if prop_array.length > 0
      prop_array += ":#{prop}"
      
    end if (object_hash.has_key? 'properties')

    new_c.const_set :PROPERTIES, eval("[#{prop_array}]")

    # add mixins to the class
    object_hash['mixins'].split(',').map do |mixin|
      #TODO:make this next part sandbox safe
      log.debug {"adding mixin #{mixin} to #{new_c}"}
      new_c.instance_eval "include #{mixin}"
    end if (object_hash.has_key? 'mixins')

    # add methods to class
    object_hash.each do |key, value|
      unless key.match(/super|parent|properties|mixins|game_object_id/)
        #TODO:make this next part sandbox safe
        log.debug {"adding method #{key} => #{value} to #{new_c}"}
        #new_c.class_eval { define_method key, eval("def #{key};#{value};end;") }
        new_c.class_eval "def #{key};#{value};end;"
      end
    end
    return new_c
  end

  def setup_object_by_hash(object_hash)
    # get the parent class for this object
    log.debug {"setting up object #{object_hash}"}
    parent_c = load_class_by_id object_hash['parent']
    log.debug {"found parent class #{parent_c}"}
    parent_c = BasicGameObject if parent_c.nil?

    new_o = parent_c.new
    new_o.game_object_id = object_hash['game_object_id']
    log.debug {"created class instance #{new_o}"}

    object_hash.each do |key,value|
      if key.match(/parent/)
        log.debug {"setting parent to #{value}"}
        new_o.instance_variable_set "@#{key}", value
        
      else
        # check if value is a number
        log.debug {"checking '#{value}' for known cases"}
        if value.match(/^\d*$/)
          log.debug "#{value} is a number"
          new_o.instance_variable_set "@#{key}", value.to_i

        elsif value.match(/^\$\$\{(\w*)\}.?(new|instance)?$/)
          log.debug "#{value} is an object"
          results = value.match(/^\$\$\{(\w*)\}.?(new|instance)?$/)
          new_c = load_class_by_id(results[1])
          sub_o = nil
          if(results[2] == 'new')
            log.debug "#{value} requires a new object"
            sub_o = new_c.new

          elsif(results[2] == 'instance')
            log.debug "#{value} requires a singleton instance"
            if new_c.included_modules.include? Singleton
              sub_o = new_c.instance
            else
              sub_o = new_c.new
            end
          end

          log.debug "setting #{key} to #{sub_o}"
          new_o.instance_variable_set "@#{key}", sub_o

        else
          log.debug "setting #{key} to #{value}"
          new_o.instance_variable_set "@#{key}", value
        end
      end
    end
    return new_o
  end

  def build_object_by_hash(object_hash)
    return setup_class_by_hash object_hash if (object_hash.has_key? 'super' or object_hash.has_key? :super)
    return setup_object_by_hash object_hash if (object_hash.has_key? 'parent' or object_hash.has_key? :parent)
  end

  # removes an object id from the cache
  # [object_id] the object id to remove from cache
  def self.remove_from_cache(object_id)
    GameObjectLoader.instance.remove_from_cache object_id
  end

  # removes an object id from the cache
  # [object_id] the object id to remove from cache
  def remove_from_cache(object_id)
    @cache.delete object_id
  end
  private :load_object_by_id, :build_object_by_hash, :setup_class_by_hash, :setup_object_by_hash, :load_class_by_id
end