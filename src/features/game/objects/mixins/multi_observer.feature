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

Feature: test the observer mixin
  As a game with autonomous agents, I need to raise events
  So I need to test the observer mixin

  Scenario: test registering and deleting observers
    Given a new observable object
    When I add a new observer
    And I delete the observer
    Then there should be no observers

  Scenario: test registering and deleting all observers
    Given a new observable object
    When I add a new observer
    And I delete all observers
    Then there should be no observers

  Scenario: test registering and firing an event
    Given a new observable object
    When I add a new observer
    And I fire the event
    Then the event should have been fired

  Scenario: test registering and firing an event with no changes
    Given a new observable object
    When I add a new observer
    And I fire the event without marking it changed
    Then the event should not have been fired

  Scenario: test registering and firing an event with arguments
    Given a new observable object
    When I add a new observer with arguments
    And I fire the event with arguments
    Then the event should have been fired with arguments