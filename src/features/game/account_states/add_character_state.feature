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