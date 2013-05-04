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

module Contained
  PROPERTIES = [:container].freeze

  attr_reader :container

  def container=(container)
    if container.nil?
      GameObjects.remove_tag 'contained', self.game_object_id
      @container = nil
    else
      game_object_id = container.is_a?(BasicGameObject) ? container.game_object_id : container # if we get an object, then pull id.  if not, then assume contained is the id
      raise 'Container cannot contain itself' if self.game_object_id == game_object_id
      GameObjects.add_tag 'contained', self.game_object_id, {'object_id' => self.game_object_id, 'container' => game_object_id}
      @container = game_object_id
    end
  end
end