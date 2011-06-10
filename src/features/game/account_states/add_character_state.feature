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

Feature: test AddCharacterState finite state machine state
  As a game I use a finite state machine for my login menu
  So test the AddCharacterState state

Scenario: test the enter method of AddCharacterState
  Given an instance of AddCharacterState
  When I call the enter method of AddCharacterState
  Then I should get appropriate output from AddCharacterState 1

Scenario: test the execute method of AddCharacterState with an empty name
  Given an instance of AddCharacterState
  When I call the execute method of AddCharacterState with the name "" and the name is "n/a"
  Then I should get "" and change to state "MainMenuState" from AddCharacterState

Scenario: test the execute method of AddCharacterState with a valid and available name
  Given an instance of AddCharacterState
  When I call the execute method of AddCharacterState with the name "Jeff" and the name is "available"
  Then I should get "Added new character named Jeff." and change to state "MainMenuState" from AddCharacterState
  
Scenario: test the execute method of AddCharacterState with a valid and unavailable name
  Given an instance of AddCharacterState
  When I call the execute method of AddCharacterState with the name "Jeff" and the name is "unavailable"
  Then I should get "That name is already taken." and change to state "AddCharacterState" from AddCharacterState

Scenario: test the execute method of AddCharacterState with an invalid name
  Given an instance of AddCharacterState
  When I call the execute method of AddCharacterState with the name "-jeff" and the name is "n/a"
  Then I should get "Invalid character name.  Name should start with a capital letter." and change to state "AddCharacterState" from AddCharacterState