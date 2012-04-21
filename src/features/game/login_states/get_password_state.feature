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

Feature: test get_password_state finite state machine state
  As a game I use a finite state machine for my login menu
  So test the get password state

Scenario: test the enter method
  Given an instance of GetPasswordState
  When I call the enter method of GetPasswordState
  Then I should get appropriate output from GetPasswordState 1

Scenario: test the exit method
  # this is a placeholder as the exit method of this class doesn't do anything

Scenario: test the execute method with invalid password
  Given an instance of GetPasswordState
  When I call the execute method of GetPasswordState with an invalid password
  Then I should get appropriate output from GetPasswordState 2

Scenario: test the execute method with a valid password
  Given an instance of GetPasswordState
  When I call the execute method of GetPasswordState with a valid password
  Then I should get appropriate output from GetPasswordState 3
  And I should get an appropriate client hash for GetPasswordState 3

Scenario: test the execute method with an invalid password three times
  Given an instance of GetPasswordState
  When I call the execute method of GetPasswordState with an invalid password thrice
  Then I should get appropriate output from GetPasswordState 4