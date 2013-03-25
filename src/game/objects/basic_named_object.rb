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

require 'game/objects/basic_persistent_game_object'

class BasicNamedObject < BasicPersistentGameObject
  PROPERTIES = [:name, :alias, :object_tag].freeze
  attr_accessor :name, :alias, :object_tag

  VERBS = {}.freeze

  def name
    if @name.nil?
      "##{self.game_object_id}"
    else
      @name
    end
  end

  def save
    super
    register_game_object
    @player.send_to_client "#{self.name} saved.\n" unless @player.nil?
  end

  def recycle
    super
    unregister_game_object
    @player.send_to_client "#{self.name} recycled.\n" unless @player.nil?
  end

  def register_game_object
    unless @object_tag.nil?
      unless @name.nil?
        log.debug {"adding tag for #@name"}
        GameObjects.add_tag @object_tag.to_s, @name, {'object_id' => @game_object_id}
      end

      unless @alias.nil?
        @alias.split(" ").each do |an_alias|
          log.debug {"adding tag for #{an_alias}"}
          GameObjects.add_tag @object_tag.to_s, an_alias, {'object_id' => @game_object_id}
        end
      end
    end
  end

  def unregister_game_object
    unless @object_tag.nil?
      unless @name.nil?
        log.debug {"removing tag for #@name"}
        GameObjects.remove_tag @object_tag.to_s, @name
      end

      unless @alias.nil?
        @alias.split(" ").each do |an_alias|
          log.debug {"removing tag for #{an_alias}"}
          GameObjects.remove_tag @object_tag.to_s, an_alias
        end
      end
    end
  end

  private :register_game_object, :unregister_game_object
end