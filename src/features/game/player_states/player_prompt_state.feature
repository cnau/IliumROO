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

Feature: test PlayerPromptState finite state machine state
  As a game I use a finite state machine for my player prompt
  So test the PlayerPromptState

  Scenario: test the enter method of PlayerPromptState
    Given an instance of PlayerPromptState
    And a mocked entity for PlayerPromptState
    And an entity expecting to receive a prompt for PlayerPromptState
    When I call the enter method of PlayerPromptState
    Then I should get an appropriate prompt from PlayerPromptState

  Scenario: test the execute method of PlayerPromptState with a client
    Given an instance of PlayerPromptState
    And a mocked process_command method for PlayerPromptState
    And a mocked entity for PlayerPromptState
    And an entity with last_client_data of "foo" for PlayerPromptState
    And an entity with a non-nil client for PlayerPromptState
    And an entity expecting a change of state for PlayerPromptState
    When I call the execute method of PlayerPromptState
    Then I should get redirected to "PlayerPromptState" by PlayerPromptState

  Scenario: test the execute method of PlayerPromptState with a client
    Given an instance of PlayerPromptState
    And a mocked process_command method for PlayerPromptState
    And a mocked entity for PlayerPromptState
    And an entity with last_client_data of "foo" for PlayerPromptState
    And an entity with a nil client for PlayerPromptState
    When I call the execute method of PlayerPromptState