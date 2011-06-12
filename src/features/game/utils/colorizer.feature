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

Feature: test colorizer mixin
  As a telnet game I can colorize text using ANSI color codes
  So let's test the colorization algorithm

  Scenario: test colorize with a single color token and ANSI enabled
    Given a string to colorize with a single color token and ANSI codes
    When I colorize the string with display type "ANSI"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with multiple color tokens and ANSI enabled
    Given a string to colorize with multiple color tokens and ANSI codes
    When I colorize the string with display type "ANSI"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with multiple color tokens on the beginning and ending of the string with ANSI enabled
    Given a string to colorize with multiple color tokens on the end of the string and ANSI codes
    When I colorize the string with display type "ANSI"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with a single color token
    Given a string to colorize with a single color token
    When I colorize the string with display type "ASCII"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with multiple color tokens
    Given a string to colorize with multiple color tokens
    When I colorize the string with display type "ASCII"
    Then I should get appropriate color codes for that single token

  Scenario: test colorize with multiple color tokens on the beginning and ending of the string
    Given a string to colorize with multiple color tokens on the end of the string
    When I colorize the string with display type "ASCII"
    Then I should get appropriate color codes for that single token