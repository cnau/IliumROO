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

Feature: persistent game object
  As a game I need to persist my objects
  So that the game maintains state

  Scenario: test persistent game object constructor
    Given a persistent game object instance
    Then parent should be BasicPersistentGameObject

  Scenario: create a new persistent game object class
    Given a mocked persistent class
    When I request the persistent class
    Then I get the correct class object

  Scenario: create a new persistent object instance
    Given a mocked persistent object
    When I request a new persistent object
    Then I get the correct persistent object

  Scenario: save a new persistent object instance
    Given a mocked persistent object to save
    And a mocked save database function
    When I load a persistent object instance
    And I save a persistent object instance
    Then the object should save

  Scenario: create a new instance of a game object class
    Given a mocked persistent class 2
    When I load a persistent class 2
    And I create an object instance from persistent class 2
    And I change some properties in persistent object
    Given a mocked save function 2
    Then I save the persistent object 2
    Then the object should save 2

  Scenario: test recycling of persistent game object
    Given a mocked persistent object 3
    And a mocked recycle database function 3
    When I load a persistent object instance 3
    And I recycle a persistent object instance 3
    Then the object should recycle