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
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>

Feature: named object
  As a game I need to name my objects
  So that players can identify the object

  Scenario: test a named object's constructor
    Given a named game object instance
    Then parent should be BasicNamedObject

  Scenario: test a named object's properties
    Given a new named object instance
    And a mocked game object save call
    When I save it, I should get a new object id
    And I should have the correct properties in the hash
    Then I should get an appropriate output message for the user