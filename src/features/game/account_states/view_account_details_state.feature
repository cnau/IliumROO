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

Feature: test ViewAccountDetailsState finite state machine state
  As a game I use a finite state machine for my menu
  So test the ViewAccountDetailsState

  Scenario: test the execute method
    Given an instance of ViewAccountDetailsState
    And a mocked entity for ViewAccountDetailsState
    And an entity expecting a change of state for ViewAccountDetailsState
    When I call the execute method of ViewAccountDetailsState
    Then I should get redirected to "MainMenuState" by ViewAccountDetailsState

  Scenario: test the enter method with no accounts
    Given an instance of ViewAccountDetailsState
    And a mocked entity for ViewAccountDetailsState
    And an entity expecting a change of state for ViewAccountDetailsState
    And an account list with names of "" and object ids of "" for ViewAccountDetailsState
    And a mocked GameObjects returning the account list for ViewAccountDetailsState
    When I call the enter method of ViewAccountDetailsState
    Then I should get redirected to "MainMenuState" by ViewAccountDetailsState
    
  Scenario: test the enter method with an invalid index choice
    Given an instance of ViewAccountDetailsState
    And a mocked entity for ViewAccountDetailsState
    And an entity expecting a change of state for ViewAccountDetailsState
    And an entity with last_client_data of "2" for ViewAccountDetailsState
    And an account list with names of "Acct-1" and object ids of "acct-1" for ViewAccountDetailsState
    And a mocked GameObjects returning the account list for ViewAccountDetailsState
    When I call the enter method of ViewAccountDetailsState
    Then I should get redirected to "MainMenuState" by ViewAccountDetailsState

  Scenario: test the enter method with a valid index choice
    Given an instance of ViewAccountDetailsState
    And a mocked entity for ViewAccountDetailsState
    And an entity with last_client_data of "1" for ViewAccountDetailsState
    And an entity with display type of "ASCII" for ViewAccountDetailsState
    And an entity expecting to receive a menu for ViewAccountDetailsState
    And an account list with names of "Acct-1" and object ids of "acct-1" for ViewAccountDetailsState
    And a mocked client account get_account call with account id of "acct-1" for ViewAccountDetailsState
    And a mocked GameObjects returning the account list for ViewAccountDetailsState
    When I call the enter method of ViewAccountDetailsState
    Then I should get an appropriate output message for ViewAccountDetailsState
