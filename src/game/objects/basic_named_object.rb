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
    @command_args[:player].send_to_client "#{self.name} saved.\n" unless @command_args.nil?
  end

  def recycle
    super
    unregister_game_object
    @command_args[:player].send_to_client "#{self.name} recycled.\n" unless @command_args.nil?
  end

  def register_game_object
    unless @object_tag.nil?
      unless @name.nil?
        log.debug {"adding tag for #{@name}"}
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
        log.debug {"removing tag for #{@name}"}
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