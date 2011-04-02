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
    Given a named game object instance 1
    Then parent should be BasicNamedObject

  Scenario: test a named object's properties
    Given a named game object instance 2
    And a mocked game object save call 2
    When I save it 2
    Then I should have the correct properties in the hash 2
    And I should get an appropriate output message for the user 2

  Scenario: test a named objects name
    Given a named object instance 3
    And a mocked game object save call 3
    When I save it 3
    Then I should have the correct properties in the hash 3
    And I should get an appropriate output message for the user 3

  Scenario: test object tags
    Given a named object instance 4
    And a mocked game object save call 4
    When I save it 4
    Then I should have the correct properties in the hash 4
    And I should get an appropriate output message for the user 4

  Scenario: test object alias
    Given a named object instance 5
    And a mocked game object save call 5
    When I save it 5
    Then I should have the correct properties in the hash 5
    And I should get an appropriate output message for the user 5

  Scenario: test object alias with tag
    Given a named object instance 6
    And a mocked game object save call 6
    When I save it 6
    Then I should have the correct properties in the hash 6
    And I should get an appropriate output message for the user 6

  Scenario: test named object recylcing
    Given a named object instance 7
    And a mocked game object save call 7
    When I save it 7
    And I recycle it
    Then I should have the correct properties in the hash 7
