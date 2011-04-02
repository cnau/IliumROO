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

Feature: database
  As a game I want a database
  So that I can persist data
  
  Scenario: test system log super column family
    Given I have a clean test category for the system log
    When I insert a new log entry
    Then the inserted log entry should not be empty
    And the log entry should be the same as I inserted
    Then I need to clean up the system log
    
  Scenario: test objects column family
    Given I have a clean objects test key
    When I insert a new object
    Then the inserted object should not be empty
    Then I need to clean up the test key

  Scenario: test object tags super column family
    Given I have a clean unit testing tag
    When I insert two new rows
    Then the there should be two rows returned
    And each row should have two columns
    Then I need to clean up the test object tag