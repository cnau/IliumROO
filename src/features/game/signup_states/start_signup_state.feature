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

Feature: test StartSignupState finite state machine state
  As a game I use a finite state machine for my signup menu
  So test the StartSignupState

  Scenario: test the enter method of StartSignupState
    Given an instance of StartSignupState
    And a mocked entity for StartSignupState
    And an entity with an email address of "test@test.com" for StartSignupState
    And an entity expecting to receive a prompt for StartSignupState
    When I call the enter method of StartSignupState
    Then I should get "Give me a password for test@test.com:" from StartSignupState

  Scenario: test the execute method of StartSignupState with no client data
    Given an instance of StartSignupState
    And a mocked entity for StartSignupState
    And an entity with last_client_data of "" for StartSignupState
    And an entity expecting to receive a prompt for StartSignupState
    And an entity expecting a change of state for StartSignupState
    When I call the execute method of StartSignupState
    Then I should get "Invalid password.  Please try again." from StartSignupState
    And I should get redirected to "StartSignupState" by StartSignupState

  Scenario: test the execute method of StartSignupState with client data and no existing accounts
    Given an instance of StartSignupState
    And a mocked entity for StartSignupState
    And a mocked client for StartSignupState
    And a ClientAccount expecting to create a new client account with email "test@test.com" and password "password" for StartSignupState
    And a client expecting to set_last_login for StartSignupState
    And an entity and client expecting attach and detach client calls for StartSignupState
    And an entity with the mocked client for StartSignupState
    And an entity with last_client_data of "password" for StartSignupState
    And an entity with email address of "test@test.com" for StartSignupState
    And a mocked Password update function with password of "password" for StartSignupState
    And a ClientAccount with account_count of "1" for StartSignupState
    And an ClientAccount expecting to receive a prompt for StartSignupState
    And a ClientAccount expecting a change of state for StartSignupState
    And a ClientAccount expecting to get set as admin and saved
    When I call the execute method of StartSignupState
    Then I should get "This is the first account created in this database.  Setting account as admin." from StartSignupState
    And the ClientAccount should get redirected to "MainMenuState" by StartSignupState

  Scenario: test the execute method of StartSignupState with client data and existing accounts
    Given an instance of StartSignupState
    And a mocked entity for StartSignupState
    And a mocked client for StartSignupState
    And a ClientAccount expecting to create a new client account with email "test@test.com" and password "password" for StartSignupState
    And a client expecting to set_last_login for StartSignupState
    And an entity and client expecting attach and detach client calls for StartSignupState
    And an entity with the mocked client for StartSignupState
    And an entity with last_client_data of "password" for StartSignupState
    And an entity with email address of "test@test.com" for StartSignupState
    And a mocked Password update function with password of "password" for StartSignupState
    And a ClientAccount with account_count of "2" for StartSignupState
    And a ClientAccount expecting a change of state for StartSignupState
    When I call the execute method of StartSignupState
    And the ClientAccount should get redirected to "MainMenuState" by StartSignupState