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
require 'game/utils/colorizer'

class DisplayOptionsState
  include Singleton
  include Colorizer

  def enter(entity)
    menu = ""
    if entity.display_type == 'ANSI'
      menu << "[blue]1.[white] turn off ANSI color\n"
    else
      menu << "[blue]1.[white] turn on ANSI color\n"
    end
    menu << "[white]choose and perish:"
    menu = colorize(menu, entity.display_type)

    entity.send_to_client menu
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.empty?
      entity.change_state MainMenuState
    else
      case entity.last_client_data
        when '1'
          if entity.display_type == 'ANSI'
            entity.display_type = 'NONE'
          else
            entity.display_type = 'ANSI'
          end
          entity.save
          entity.change_state MainMenuState
        else
          entity.send_to_client "Invalid choice.\n"
          entity.change_state DisplayOptionsState
      end
    end
  end
end