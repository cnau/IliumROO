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

Feature: test the state machine mixin
  As a game with autonomous agents, I need a finite state machine
  So I need to test the finite state machine

  Scenario: test a state machine's global state setter and getter
    Given a new basic state machine object 1
    And a new entity object 1
    When I set the global state 1
    And I update state 1
    Then the global state should be set properly

  Scenario: test a state machine's change state method
    Given a new basic state machine object 2
    And a new entity object 2
    When I change state 2
    Then I should see the correct state transition 2

  Scenario: test a state machine's update method
    Given a new basic state machine object 3
    And a new entity object 3
    When I change state 3
    And I update state 3
    Then I should see the correct state transition 3

  Scenario: test a state machine's multi-state transition
    Given a new basic state machine object 4
    And a new entity object 4
    When I set the initial state
    And I change state 4
    And I update state 4
    Then I should see the correct state transition 4
    When I revert to the previous state
    Then I should see the correct revert state transition