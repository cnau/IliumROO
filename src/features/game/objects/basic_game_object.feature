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

Feature: test basic game object
  As a game I need game objects
  So let's test our basic game object

  Scenario: test a basic game object's class functions
    Given a BasicGameObject class
    When I request verbs
    And when I request properties
    Then I should get appropriate values

  Scenario: test a basic game object's properties
    Given a new BasicGameObject instance
    When I check game object id
    Then I should get a valid game object id
    And I should be able to see that id in the object's to_hash function

  Scenario: test game object's client wrapper mixin
    Given an instance of BasicGameObject
    When I mock a client object
    And I attach the mock client object to the game object
    Then the client object should be attached

  Scenario: test game object's client wrapper mixin's verbs
    Given an instance of BasicGameObject 2
    When I mock a client object 2
    And I attach the client object to the game object 2
    And I test the verbs for the client wrapper
    Then the verbs should work properly

  Scenario: test a game object's state machine mixin
    Given an instance of BasicGameObject 3
    When I mock a couple of state classes
    And I change the state of BasicGameObject
    Then I expect the state changes to take place
    When I revert the state
    Then I expect the state to be reverted

  Scenario: test a game object's global state
    Given an instance of BasicGameObject 4
    When I mock a global state
    And I assign the global state to the game object
    Then I expect the state change to take place