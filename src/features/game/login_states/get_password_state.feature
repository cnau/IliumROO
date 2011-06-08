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

Feature: test get_password_state finite state machine state
  As a game I use a finite state machine for my login menu
  So test the get password state

Scenario: test the enter method
  Given an instance of GetPasswordState
  When I call the enter method of GetPasswordState
  Then I should get appropriate output from GetPasswordState 1

Scenario: test the exit method
  # this is a placeholder as the exit method of this class doesn't do anything

Scenario: test the execute method with invalid password
  Given an instance of GetPasswordState
  When I call the execute method of GetPasswordState with an invalid password
  Then I should get appropriate output from GetPasswordState 2

Scenario: test the execute method with a valid password
  Given an instance of GetPasswordState
  When I call the execute method of GetPasswordState with a valid password
  Then I should get appropriate output from GetPasswordState 3
  And I should get an appropriate client hash for GetPasswordState 3

Scenario: test the execute method with an invalid password three times
  Given an instance of GetPasswordState
  When I call the execute method of GetPasswordState with an invalid password thrice
  Then I should get appropriate output from GetPasswordState 4