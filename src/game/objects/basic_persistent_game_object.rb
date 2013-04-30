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

require 'game/objects/basic_owned_object'

class BasicPersistentGameObject < BasicGameObject
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

  def save
    obj_hash = self.to_h
    log.debug {"saving hash #{obj_hash}"}
    obj_id = obj_hash[:game_object_id]
    GameObjects.save(obj_id, obj_hash) unless obj_id.nil?
  end

  def recycle
    if self.class.properties.include? :name then
      obj_name = self.name
    else
      obj_name = self.game_object_id
    end
    GameObjects.add_tag 'recycled', obj_name, {'object_id' => self.game_object_id}
  end
end