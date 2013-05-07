#Copyright (c) 2009-2012 Christian Nau

#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:

#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Feature: test EnterWorldState finite state machine state
  As a game I use a finite state machine for my login menu
  So test the EnterWorldState state

  Scenario: test the enter method with no characters
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity is expecting a new state from EnterWorldState
    And this character list "" with a name of ""
    When I call the enter method of EnterWorldState
    Then I should get redirected to "MainMenuState" by EnterWorldState

  Scenario: test the enter method a character
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And this character list "char-1" with a name of "CharOne"
    When I call the enter method of EnterWorldState
    Then I should get an appropriate menu for EnterWorldState

  Scenario: test the execute method with empty last client data
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity has last client data of "" for EnterWorldState
    And the mocked entity is expecting a new state from EnterWorldState
    When I call the execute method of EnterWorldState
    Then I should get redirected to "MainMenuState" by EnterWorldState

  Scenario: test the execute method with an invalid index
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity has last client data of "2" for EnterWorldState
    And the mocked entity is expecting a new state from EnterWorldState
    And this character list "char-1" with a name of ""
    When I call the execute method of EnterWorldState
    Then I should get redirected to "EnterWorldState" by EnterWorldState

  Scenario: test the execute method with a valid index and no map or startup map
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity has last client data of "1" for EnterWorldState
    And the mocked entity has a mocked client for EnterWorldState
    And this character list "char-1" with a name of ""
    And a mocked GameObjectLoader for EnterWorldState
    And the mocked player object is expecting to attach the entity client
    And the old entity is expecting to detach client for EnterWorldState
    And the player object is expecting a new state from EnterWorldState
    And the player object has a map of "" and start location of ""
    And a startup map of "" and start location of "" and expect to look for startup "true"
    When I call the execute method of EnterWorldState
    Then I should get redirected to "PlayerPromptState" by EnterWorldState

  Scenario: test the execute method with a valid index and no map but a startup map
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity has last client data of "1" for EnterWorldState
    And the mocked entity has a mocked client for EnterWorldState
    And this character list "char-1" with a name of ""
    And a mocked GameObjectLoader for EnterWorldState
    And the mocked player object is expecting to attach the entity client
    And the old entity is expecting to detach client for EnterWorldState
    And the player object is expecting a new state from EnterWorldState
    And the player object has a map of "" and start location of ""
    And a startup map of "startup_map" and start location of "[0,1,0]" and expect to look for startup "true"
    When I call the execute method of EnterWorldState
    Then I should get redirected to "PlayerPromptState" by EnterWorldState

  Scenario: test the execute method with a valid index and a map but no startup map
    Given an instance of EnterWorldState
    And a mocked entity for EnterWorldState
    And the mocked entity has last client data of "1" for EnterWorldState
    And the mocked entity has a mocked client for EnterWorldState
    And this character list "char-1" with a name of ""
    And a mocked GameObjectLoader for EnterWorldState
    And the mocked player object is expecting to attach the entity client
    And the old entity is expecting to detach client for EnterWorldState
    And the player object is expecting a new state from EnterWorldState
    And the player object has a map of "player_map" and start location of "[0,1,0]"
    And a startup map of "" and start location of "" and expect to look for startup "false"
    When I call the execute method of EnterWorldState
    Then I should get redirected to "PlayerPromptState" by EnterWorldState