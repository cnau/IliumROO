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

Feature: test start login state finite state machine state
  As a game I use a finite state machine for my login menu
  So test the start login state

Scenario: test the enter method
  Given an instance of StartLoginState
  When I call the enter method of StartLoginState
  Then I should get appropriate output from StartLoginState 1

Scenario: test the execute method with an invalid email
  Given an instance of StartLoginState
  When I call the execute method of StartLoginState with an invalid email
  Then I should get appropriate output from StartLoginState 2

Scenario: test the execute method with an invalid email thrice
  Given an instance of StartLoginState
  When I call the execute method of StartLoginState with an invalid email thrice
  Then I should get appropriate output from StartLoginState 3

Scenario: test the execute method with a valid email and a nil account id
  Given an instance of StartLoginState
  When I call the execute method of StartLoginState with a valid email and a nil account id
  Then I should get appropriate output from StartLoginState 4

Scenario: test the execute method with a valid email and a non-nil account id
  Given an instance of StartLoginState
  When I call the execute method of StartLoginState with a valid email and a non-nil account id
  Then I should get appropriate output from StartLoginState 5