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

Feature: test MainMenuState finite state machine state
  As a game I use a finite state machine for my menu
  So test the MainMenuState

  Scenario: test the enter method of MainMenuState
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting to receive a menu for MainMenuState
    And an entity with account type of "admin" for MainMenuState
    And an entity with display type of "NONE" for MainMenuState
    And a generated main menu with account type of "admin"
    When I call the enter method of MainMenuState
    Then I should get appropriate output from MainMenuState

  Scenario: test the execute method of MainMenuState with an invalid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting to receive a menu for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "7" for MainMenuState
    And a generated invalid option message for MainMenuState
    When I call the execute method of MainMenuState
    Then I should get appropriate output from MainMenuState
    And I should get redirected to "MainMenuState" by MainMenuState
    
  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "1" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "EnterWorldState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "2" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "AddCharacterState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "3" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "DeleteCharacterState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "4" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "DisplayOptionsState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "5" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "LogoutState" by MainMenuState

  Scenario: test the execute method of MainMenuState with a valid menu choice
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "6" for MainMenuState
    And an entity with account type of "admin" for MainMenuState
    When I call the execute method of MainMenuState
    And I should get redirected to "ListAccountsState" by MainMenuState
    
  Scenario: test the execute method of MainMenuState with a valid menu choice and an invalid account type
    Given an instance of MainMenuState
    And a mocked entity for MainMenuState
    And an entity expecting a change of state for MainMenuState
    And an entity with last_client_data of "6" for MainMenuState
    And an entity with account type of "" for MainMenuState
    And an entity expecting to receive a menu for MainMenuState
    And a generated invalid option message for MainMenuState
    When I call the execute method of MainMenuState
    Then I should get appropriate output from MainMenuState
    And I should get redirected to "MainMenuState" by MainMenuState