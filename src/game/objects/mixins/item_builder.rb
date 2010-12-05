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

module ItemBuilder
  VERBS = {:create => {:prepositions => [:as]}}.freeze

  def create
    # try to get the class for the new item
    new_item_c = GameObjectLoader.load_object @iobjstr
    if new_item_c.nil?
      @player.send_to_client "#{@iobjstr} is not a known Class.\n"

    elsif new_item_c.is_a? Class
      @player.send_to_client "creating #{@dobjstr} as #{new_item_c}\n"
      new_item_o = new_item_c.new

    else
      @player.send_to_client "#{@iobjstr} is an Object, not a Class.\n"
    end
  end
end