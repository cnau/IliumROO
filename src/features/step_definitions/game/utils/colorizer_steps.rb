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
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"
require "game/utils/colorizer"

Given /^a string to colorize with a single color token and ANSI codes$/ do
  @string_to_colorize = "[blue]blue text"
  @expected_string = "" << Colorizer::ESC << Colorizer::COLORS["blue"] << "blue text"
end

When /^I colorize the string with display type "([^"]*)"$/ do |display_type|
  @colorized_string = Colorizer::colorize(@string_to_colorize, display_type)
  @colorized_string.should_not be_nil
end

Then /^I should get appropriate color codes for that single token$/ do
  @colorized_string.should eql @expected_string
end

Given /^a string to colorize with multiple color tokens and ANSI codes$/ do
  @string_to_colorize = "[blue]blue[white]white[normal]normal[cyan]cyan[back_red]back red"
  @expected_string = "" <<
      Colorizer::ESC << Colorizer::COLORS["blue"]     << "blue"   <<
      Colorizer::ESC << Colorizer::COLORS["white"]    << "white"  <<
      Colorizer::ESC << Colorizer::COLORS["normal"]   << "normal" <<
      Colorizer::ESC << Colorizer::COLORS["cyan"]     << "cyan"   <<
      Colorizer::ESC << Colorizer::COLORS["back_red"] << "back red"
end

Given /^a string to colorize with multiple color tokens on the end of the string and ANSI codes$/ do
  @string_to_colorize = "[blue][white][red]"
  @expected_string = "" <<
      Colorizer::ESC <<  Colorizer::COLORS["blue"] <<
      Colorizer::ESC << Colorizer::COLORS["white"] <<
      Colorizer::ESC << Colorizer::COLORS["red"]
end

Given /^a string to colorize with a single color token$/ do
  @string_to_colorize = "[blue]blue text"
  @expected_string = "" << "blue text"
end

Given /^a string to colorize with multiple color tokens$/ do
  @string_to_colorize = "[blue]blue[white]white[normal]normal[cyan]cyan[back_red]back red"
  @expected_string = "" << "blue" << "white" << "normal" << "cyan" << "back red"
end

Given /^a string to colorize with multiple color tokens on the end of the string$/ do
  @string_to_colorize = "[blue][white][red]"
  @expected_string = ""
end