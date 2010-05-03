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

module Colorizer
  ESC = 0x1b

  COLORS = {"reset" => "[0m", "bold" => "[1m", "italics_on" => "[3m", "underline_on" => "[4m",
      "inverse_on" => "[7m", "strikethrough_on" => "[9m", "bold_off" => "[22m", "italics_off" => "[23m",
      "underline_off" => "[24m", "inverse_off" => "[27m", "strikethrough_off" => "[29m",
      "black" => "[30m", "red" => "[31m", "green" => "[32m", "yellow" => "[33m", "blue" => "[34m",
      "purple" => "[35m", "cyan" => "[36m", "white" => "[37m", "default" => "[39m", "back_black" => "[40m",
      "back_red" => "[41m", "back_green" => "[42m", "back_yellow" => "[43m", "back_blue" => "[44m",
      "back_purple" => "[45m", "back_cyan" => "[46m", "back_white" => "[47m", "back_default" => "[49m",
      "bred" => "[1;31m", "bgreen" => "[1;32m", "byellow" => "[1;33m", "bblue" => "[1;34m",
      "bpink" => "[1;35m", "bcyan" => "[1;36m", "bwhite" => "[1;37m", "normal" => "[0m"}

  def colorize(to_colorize)
    pos = to_colorize.index("[")
    if pos.nil? then
      return to_colorize
    else
      pre = ""
      next_pos = to_colorize.index("]", pos)
      pre = to_colorize[0..pos-1] if pos > 0
      color = to_colorize[(pos+1)..(next_pos-1)] unless next_pos.nil?
      the_rest = to_colorize[(next_pos + 1)..to_colorize.length] unless next_pos.nil?

      color = "" << ESC << COLORS[color.downcase] if COLORS.include? color.downcase

      return pre << color << colorize(the_rest)
    end
  end
end