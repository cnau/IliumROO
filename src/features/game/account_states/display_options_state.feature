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

Feature: test DisplayOptionsState finite state machine state
  As a game I use a finite state machine for my login menu
  So test the DisplayOptionsState state

  Scenario: test a DisplayOptionsState enter method with ANSI turned on
    Given an instance of DisplayOptionsState
    When I have a display type of "ANSI" for the enter method
    And I call the enter method of DisplayOptionsState
    Then I should get appropriate output from DisplayOptionsState enter method

   Scenario: test a DisplayOptionsState enter method with ANSI turned off
    Given an instance of DisplayOptionsState
    When I have a display type of "NONE" for the enter method
    And I call the enter method of DisplayOptionsState
    Then I should get appropriate output from DisplayOptionsState enter method

  Scenario: test a DisplayOptionsState execute method with ANSI turned on
    Given an instance of DisplayOptionsState
    And a mocked entity
    When I have a display type of "ANSI" for the execute method
    And I have a client data of ""
    And I call the execute method of DisplayOptionsState
    Then I should get redirected to "MainMenuState" by DisplayOptionsState
    
  Scenario: test a DisplayOptionsState execute method with an invalid last client data
    Given an instance of DisplayOptionsState
    And a mocked entity
    And an entity expecting output of "Invalid choice."
    When I have a display type of "ANSI" for the execute method
    And I have a client data of "2"
    And I call the execute method of DisplayOptionsState
    Then I should get appropriate output from DisplayOptionsState execute method
    And I should get redirected to "DisplayOptionsState" by DisplayOptionsState

  Scenario: test a DisplayOptionsState execute method with a valid last client data
    Given an instance of DisplayOptionsState
    And a mocked entity
    And an entity expecting a display type of "NONE"
    And an entity expecting to be saved
    When I have a display type of "ANSI" for the execute method
    And I have a client data of "1"
    And I call the execute method of DisplayOptionsState
    And I should get redirected to "MainMenuState" by DisplayOptionsState

  Scenario: test a DisplayOptionsState execute method with a valid last client data
    Given an instance of DisplayOptionsState
    And a mocked entity
    And an entity expecting a display type of "ANSI"
    And an entity expecting to be saved
    When I have a display type of "NONE" for the execute method
    And I have a client data of "1"
    And I call the execute method of DisplayOptionsState
    And I should get redirected to "MainMenuState" by DisplayOptionsState
