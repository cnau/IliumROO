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

Feature: test DeleteCharacterState finite state machine state
  As a game I use a finite state machine for my login menu
  So test the DeleteCharacterState state

  Scenario: test the enter method without characters
    Given an instance of DeleteCharacterState
    When I call the enter method of DeleteCharacterState with no characters
    Then I should get redirected to "MainMenuState"


  Scenario: test the enter method with characters
    Given an instance of DeleteCharacterState
    When I call the enter method of DeleteCharacterState with character list "char-1" and name list "CharOne"
    Then I should get appropriate output from enter method of DeleteCharacterState

  Scenario: test the enter method with multiple characters
    Given an instance of DeleteCharacterState
    When I call the enter method of DeleteCharacterState with character list "char-1,char-2,char-3" and name list "CharOne,CharTwo,CharThree"
    Then I should get appropriate output from enter method of DeleteCharacterState

  Scenario: test the execute method with no characters
    Given an instance of DeleteCharacterState
    When I setup an entity with character list "" and name list ""
    And a last_client_data of ""
    And I call the execute method of DeleteCharacterState
    Then I should get redirected to "MainMenuState"

  Scenario: test the execute method with an invalid index
    Given an instance of DeleteCharacterState
    When I setup an entity with character list "char-1" and name list "CharOne"
    And a last_client_data of "2"
    And I call the execute method of DeleteCharacterState
    Then I should get redirected to "DeleteCharacterState"

  Scenario: test the execute method a valid index
    Given an instance of DeleteCharacterState
    When I setup an entity with character list "char-1,char-2" and name list "CharOne,CharTwo"
    And a last_client_data of "1"
    And I call the execute method of DeleteCharacterState
    Then I should get appropriate output from DeleteCharacterState
    And I should get redirected to "MainMenuState"