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

Feature: test verify email state finite state machine state
  As a game I use a finite state machine for my login menu
  So test the verify email state

Scenario: test enter method
  Given an instance of VerifyEmailState
  When I call the enter method of VerifyEmailState
  Then I should get appropriate output from VerifyEmailState 1

Scenario: test execute method with "no"
  Given an instance of VerifyEmailState
  When I call the execute method of VerifyEmailState with "no"
  Then I should change to the "StartLoginState"

Scenario: test execute method with "yes"
  Given an instance of VerifyEmailState
  When I call the execute method of VerifyEmailState with "yes"
  Then I should change to the "StartSignupState"