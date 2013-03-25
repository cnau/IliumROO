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

require 'game_objects/game_object_loader'
require 'game/objects/mixins/item_builder'

class PlayerAdmin 
  include ItemBuilder
  
  VERBS = {:list_items => nil, :list_players => nil, :inspect => {:alias => :inspect_object}}.freeze

  def inspect_object
    if @dobjstr.nil?
      @client.send_to_client "Inspect what?\n"
    else
      obj_id = nil
      if @dobj.nil?
        obj_id = @dobjstr
      else
        obj_id = @dobj.game_object_id
      end
      obj_hash = GameObjects.get obj_id
      if obj_hash.nil? or obj_hash.empty?
        @client.send_to_client "Can't find object #@dobjstr\n"
      else
        out = "Object #@dobjstr\n"
        out << obj_hash.inspect
        out << "\n"
        @client.send_to_client out
      end
    end
  end

  def list_players
    ret = "player name".ljust(25)
    ret << "     "
    ret << "object id".ljust(10)
    ret << "\n"
    player_list = GameObjects.get_tag 'player_names', nil
    player_list.each do |player_name, object_hash|
      ret << player_name.ljust(25)
      ret << "     "
      ret << object_hash['object_id'].center(10, " ")
      ret << "\n"
    end
    @client.send_to_client ret
  end
  
  def list_items
    if @dobjstr.nil?
      ret = "items types:\n"
      item_types = GameObjects.get_tag 'items', nil
      item_types.each do |type_name, items|
        ret << type_name << "\n"
      end
    else
      ret = "#@dobjstrs:\n"
      ret << "item name".ljust(25)
      ret << "     "
      ret << "object id".ljust(10)
      ret << "\n"
      items = GameObjects.get_tag 'items', @dobjstr
      items.each do |item_name, object_hash|
        ret << item_name.ljust(25)
        ret << "     "
        ret << object_hash['object_id'].center(10, " ")
        ret << "\n"
      end
    end
    @client.send_to_client ret
  end
end