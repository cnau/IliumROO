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

Feature: game objects
  As a game I need objects
  So that there will be something in the world
  
  Scenario: basic objects
    Given a clean test object id
    When I insert an object hash
    Then I expect that the object hash was inserted
    Then I clean up the test object id

  Scenario: different columns
    Given a clean test object id
    When I insert an object hash with different columns
    Then I expect that the object hash was inserted and is identical
    Then I clean up the test object id

  Scenario: object tags
    Given a clean tag for object "1"
    And a clean tag for object "2"
    When I insert a new tag for object "1"
    When I insert a new tag for object "2"
    Then I expect object "1" to be inserted
    Then I expect object "2" to be inserted
    And I expect both objects to be inserted
    Then that I clean up object "1"
    Then that I clean up object "2"
