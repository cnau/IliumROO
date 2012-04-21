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