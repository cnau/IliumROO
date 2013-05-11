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


# some big assumptions in this module
# 1. container MUST be a BasicGameObject
# 2. contained items MUST be a BasicGameObject

module Container
  def add_to_container(contained, container = nil, additional = {})
    game_object_id = contained.is_a?(BasicGameObject) ? contained.game_object_id : contained # if we get an object, then pull id.  if not, then assume contained is the id
    raise 'Container cannot contain itself' if self.game_object_id == game_object_id
    setup_container container
    contained_hash = {'object_id' => game_object_id}
    contained_hash.merge!(additional) if additional.is_a?(Hash)
    the_container_name = container_name(container)
    GameObjects.add_tag the_container_name, game_object_id, contained_hash
    @contents[the_container_name][game_object_id] = contained.is_a?(BasicGameObject) ? contained : contained_hash
    # set container
    contained.container = self.game_object_id if contained.is_a?(Contained)
  end

  # basic return of list without object loading
  def list_container(container = nil)
    tags = GameObjects.get_tags container_name(container)
    ret = {}
    tags.each { |k, v|
      ret[k] = v.to_h
    }
    setup_container container
    @contents[container_name(container)] = ret
    ret
  end

  def remove_from_container(contained, container = nil)
    setup_container container
    the_container_name = container_name(container)
    game_object_id = contained.is_a?(BasicGameObject) ? contained.game_object_id : contained # if we get an object, then pull id.  if not, then assume contained is the id
    GameObjects.remove_tag the_container_name, game_object_id
    @contents[the_container_name].delete(game_object_id) if @contents[the_container_name].has_key? game_object_id
    if contained.is_a?(Contained)
      contained.container = nil
    else
      GameObjects.remove_tag 'contained', game_object_id
    end
  end

  def load_container(container = nil)
    setup_container container
    the_container_name = container_name(container)
    @contents[the_container_name] = {} # clear out previous data
    tags = GameObjects.get_tags the_container_name
    tags.each { |obj_id, tag_hash|
      @contents[the_container_name][obj_id] = GameObjectLoader.load_object(obj_id)
    }
    @contents[the_container_name]
  end

  def container(container = nil)
    setup_container container
    @contents[container_name(container)]
  end

  def setup_container(container = nil)
    @contents ||= {}
    @contents[container_name(container)] ||= {}
  end

  def container_name(container = nil)
    container.nil? ? self.game_object_id : "#{self.game_object_id}_#{container.to_s}"
  end

  private :setup_container, :container_name
end