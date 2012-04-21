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

Feature: test the state machine mixin
  As a game with autonomous agents, I need a finite state machine
  So I need to test the finite state machine

  Scenario: test a state machine's global state setter and getter
    Given a new basic state machine object 1
    And a new entity object 1
    When I set the global state 1
    And I update state 1
    Then the global state should be set properly

  Scenario: test a state machine's change state method
    Given a new basic state machine object 2
    And a new entity object 2
    When I change state 2
    Then I should see the correct state transition 2

  Scenario: test a state machine's update method
    Given a new basic state machine object 3
    And a new entity object 3
    When I change state 3
    And I update state 3
    Then I should see the correct state transition 3

  Scenario: test a state machine's multi-state transition
    Given a new basic state machine object 4
    And a new entity object 4
    When I set the initial state
    And I change state 4
    And I update state 4
    Then I should see the correct state transition 4
    When I revert to the previous state
    Then I should see the correct revert state transition