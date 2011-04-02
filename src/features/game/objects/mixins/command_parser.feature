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

Feature: test the command parser
  As a game that receives text input from the user
  So I need to parse and understand what the user is requesting

  Scenario: test zero length command
    Given a mocked player object for test one
    When I parse a zero length command
    Then I should receive huh?

  Scenario: test invalid command
    Given a mocked player object for test two
    When I parse an invalid command
    Then I should receive huh?

  Scenario: test one word commands
    Given a mocked player object for test three
    When I parse a one word command
    Then I should get a correct hash

  Scenario: test a one word command with parameters "say hello there!"
    Given a mocked player object for test four
    When I parse a one word command with parameters
    Then I should get a correct hash for test four

  Scenario: test common word replacements " ;, :, " "
    Given a mocked player object for test five
    Given a player object with last_data with a quote
    When I parse a command with common word replacements
    Then I should get a correct hash substitution with verb "say"
    Given a player object with last_data with a colon
    When I parse a command with common word replacements
    Then I should get a correct hash substitution with verb "emote"

  Scenario: test me and here
    Given a mocked player object for test six
    And a player object with last_data "look me" for test six
    When I parse the command
    Then I should get a correct hash for test six

  Scenario: test prepositions
    Given a mocked player object for test seven
    And a player object with last_data "put bag" for test seven
    When I parse the command without prepositions
    Then I should receive huh? for test seven
    Given a player object with last_data "put sock in bag" for test seven
    When I parse the command with prepositions
    Then I should get a correct hash for test seven
    Given a player object with last_data "put sock with bag" for test seven
    When I parse the command with incorrect prepositions
    Then I should receive huh? for test seven

  Scenario: test aliases
    Given a mocked player object for test eight
    And a player object with last_data "put bag" for test eight
    When I parse the command with aliases
    Then I should get a correct hash for test eight

  Scenario: test aliases and prepositions
    Given a mocked player object for test nine
    And a player object with last_data "put sword in bag" for test nine
    When I parse the command with aliases and prepositions
    Then I should get a correct hash for test nine