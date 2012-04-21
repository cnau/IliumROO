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

Feature: test ListAccountsState finite state machine state
  As a game I use a finite state machine for my login menu
  So test the ListAccountsState

  Scenario: test the enter method with an empty accounts tag
    Given an instance of ListAccountsState
    And an account list with names of "" and object ids of ""
    And a mocked GameObjects returning the account list
    And a mocked entity for ListAccountsState
    And an entity expecting a change of state for ListAccountsState
    When I call the enter method of ListAccountsState
    Then I should get redirected to "MainMenuState" by ListAccountsState

  Scenario: test the enter method with some accounts
    Given an instance of ListAccountsState
    And an account list with names of "acc-1,acc-2" and object ids of "ACC-1,ACC-2"
    And a mocked GameObjects returning the account list
    And a mocked entity for ListAccountsState
    And an entity expecting to receive a menu for ListAccountsState
    And an entity with display type of "NONE" for ListAccountsState
    When I call the enter method of ListAccountsState
    Then I should get an appropriate menu for ListAccountsState

  Scenario: test the execute method with empty last client data
    Given an instance of ListAccountsState
    And a mocked entity for ListAccountsState
    And an entity with last_client_data of "" for ListAccountsState
    And an entity expecting a change of state for ListAccountsState
    When I call the execute method of ListAccountsState
    Then I should get redirected to "MainMenuState" by ListAccountsState

  Scenario: test the execute method with an invalid index
    Given an instance of ListAccountsState
    And a mocked entity for ListAccountsState
    And an entity with last_client_data of "2" for ListAccountsState
    And an entity expecting a change of state for ListAccountsState
    And an account list with names of "acc-3" and object ids of "ACC-3"
    And a mocked GameObjects returning the account list
    When I call the execute method of ListAccountsState
    Then I should get redirected to "ListAccountsState" by ListAccountsState

  Scenario: test the execute method with a valid index
    Given an instance of ListAccountsState
    And a mocked entity for ListAccountsState
    And an entity with last_client_data of "1" for ListAccountsState
    And an entity expecting a change of state for ListAccountsState
    And an account list with names of "acc-4" and object ids of "ACC-4"
    And a mocked GameObjects returning the account list
    When I call the execute method of ListAccountsState
    Then I should get redirected to "ViewAccountDetailsState" by ListAccountsState