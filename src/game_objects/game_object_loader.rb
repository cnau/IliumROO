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

    new_obj = load_object_by_id(object_id)

    if !new_obj.nil?
      #todo:make this sandbox safe
      new_obj.instance_eval "def game_object_id;return @game_object_id;end;"
      new_obj.instance_variable_set "@game_object_id", object_id
      
      log.debug {"caching object #{new_obj} as #{new_obj.game_object_id}" }
      @cache[new_obj.game_object_id] = new_obj
    end

    return new_obj
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
    obj = @cache[object_id] if @cache.has_key? object_id
    log.debug {"found #{obj} in #{@cache}"}
    return obj unless obj.nil?     # object has already been loaded

    # load the object from the database
    log.debug {"loading game object #{object_id} from database"}
    obj_hash = GameObjects.get object_id
    log.debug {"found game object #{obj_hash}"}
    return nil if obj_hash.nil? or obj_hash.empty?
    
    # build the object
    log.debug {"building object by hash #{obj_hash}"}
    new_obj = build_object_by_hash obj_hash
    return new_obj
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

  def build_class_by_hash(object_hash)
    # get the object's super class
    log.debug {"getting super class for #{object_hash}"}
    super_c = load_class_by_id(object_hash['super'])
    return nil if super_c.nil?
    log.debug {"found super class #{super_c}"}

    # create a new class derived from the super class
    log.info {"building class #{object_hash} derived from #{super_c}"}
    new_class = Class.new super_c

    log.debug {"built class #{new_class}"}

    # add properties to the class
    object_hash['properties'].split(',').map do |prop|
      #TODO:make this next part sandbox safe
      log.debug {"adding property #{prop} to #{new_class}"}
      new_class.class_eval "def #{prop};@#{prop};end;def #{prop}=(val);@#{prop} = val;end;"
    end if (object_hash.has_key? 'properties')

    # add mixins to the class
    object_hash['mixins'].split(',').map do |mixin|
      #TODO:make this next part sandbox safe
      log.debug {"adding mixin #{mixin} to #{new_class}"}
      new_class.class_eval "include #{mixin}"
    end if (object_hash.has_key? 'mixins')

    # add methods to class
    object_hash.each do |key, value|
      unless key.match(/super|parent|properties|mixins/)
        #TODO:make this next part sandbox safe
        log.debug {"adding method #{key} => #{value} to #{new_class}"}
        new_class.class_eval "def #{key};#{value};end;"
      end
    end
    return new_class
  end

  def setup_object_by_hash(object_hash)
    # get the parent class for this object
    log.info {"setting up object #{object_hash}"}
    parent_c = load_class_by_id object_hash['parent']
    log.debug {"found parent class #{parent_c}"}
    return nil if parent_c.nil?

    new_obj = parent_c.new
    log.debug {"created class instance #{new_obj}"}

    object_hash.each do |key,value|
      unless key.match(/parent/)
        # check if value is a number
        log.debug "checking '#{value}' for known cases"
        if value.match(/^\d*$/)
          log.debug "#{value} is a number"
          new_obj.instance_variable_set "@#{key}", value.to_i

        elsif value.match(/^\$\$\{(\w*)\}.?(new|instance)?$/)
          log.debug "#{value} is an object"
          results = value.match(/^\$\$\{(\w*)\}.?(new|instance)?$/)
          new_c = load_class_by_id(results[1])
          new_o = nil
          if(results[2] == 'new')
            log.debug "#{value} requires a new object"
            new_o = new_c.new

          elsif(results[2] == 'instance')
            log.debug "#{value} requires a singleton instance"
            if new_c.included_modules.include? Singleton
              new_o = new_c.instance
            else
              new_o = new_c.new
            end
          end

          log.debug "setting #{key} to #{new_o}"
          new_obj.instance_variable_set "@#{key}", new_o

        else
          log.debug "setting #{key} to #{value}"
          new_obj.instance_variable_set "@#{key}", value
        end
      end
    end

    return new_obj
  end

  def build_object_by_hash(object_hash)
    new_obj = build_class_by_hash object_hash if object_hash.has_key? 'super'
    new_obj = setup_object_by_hash object_hash if object_hash.has_key? 'parent'
    return new_obj
  end

  private :load_object_by_id, :build_object_by_hash, :build_class_by_hash, :setup_object_by_hash, :load_class_by_id
end