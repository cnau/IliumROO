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

Feature: test LogoutState finite state machine state
  As a game I use a finite state machine for my menu
  So test the LogoutState

  Scenario: test the enter method of LogoutState
    Given an instance of LogoutState
    And a mocked entity for LogoutState
    When I call the enter method of LogoutState
    Then I should get appropriate output from LogoutState