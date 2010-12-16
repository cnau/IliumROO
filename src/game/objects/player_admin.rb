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
        @client.send_to_client "Can't find object #{@dobjstr}\n"
      else
        out = "Object #{@dobjstr}\n"
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
      ret = "#{@dobjstr}s:\n"
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