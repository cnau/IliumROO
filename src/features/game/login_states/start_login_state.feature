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

Feature: test start login state finite state machine state
  As a game I use a finite state machine for my login menu
  So test the start login state

Scenario: test the enter method
  Given an instance of StartLoginState
  When I call the enter method of StartLoginState
  Then I should get appropriate output from StartLoginState 1

Scenario: test the execute method with an invalid email
  Given an instance of StartLoginState
  When I call the execute method of StartLoginState with an invalid email
  Then I should get appropriate output from StartLoginState 2

Scenario: test the execute method with an invalid email thrice
  Given an instance of StartLoginState
  When I call the execute method of StartLoginState with an invalid email thrice
  Then I should get appropriate output from StartLoginState 3

Scenario: test the execute method with a valid email and a nil account id
  Given an instance of StartLoginState
  When I call the execute method of StartLoginState with a valid email and a nil account id
  Then I should get appropriate output from StartLoginState 4

Scenario: test the execute method with a valid email and a non-nil account id
  Given an instance of StartLoginState
  When I call the execute method of StartLoginState with a valid email and a non-nil account id
  Then I should get appropriate output from StartLoginState 5