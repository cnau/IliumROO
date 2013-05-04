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

Feature: test the container mixin
  As a game with inventories
  We need to be able to store inventories and prevent duplicate items

  Scenario: test add method with error
    Given a new basic game object with container mixin
    When I add the object to itself
    Then I should have received an exception

  Scenario: test add method
    Given a new basic game object with container mixin
    When I add an object to the container "Test"
    Then the contents of the "Test" container should contain the new object

  Scenario: test add method with additional
    Given a new basic game object with container mixin
    When I add an object to the container "Test" with additional data "[0,0,0]"
    Then the contents of the "Test" container should contain the new object
    And the additional data of "[0,0,0]" should have been saved

  Scenario: test list_contents method with additional
    Given a new basic game object with container mixin
    When I add an object to the container "Test" with additional data "[0,0,0]"
    Then the list_contents function for container "Test" should contain additional data "[0,0,0]"

  Scenario: test remove method
    Given a new basic game object with container mixin
    When I add an object to the container "Test"
    Then the contents of the "Test" container should contain the new object
    When I remove an object from the container "Test"
    Then the object should have been removed from the container "Test"

  Scenario: test load_contents method
    Given a new basic game object with container mixin
    When I add several persistent objects to the container "Test"
    And I call the load_contents method for container "Test"
    Then each of the persistent objects should have been loaded and stored in container "Test"

  Scenario: test add method with game object id
    Given a new basic game object with container mixin
    When I add an object to the container "Test" with only the game object id
    Then the contents of the "Test" container should contain the game object id

  Scenario: test add method game object id and load_contents method
    Given a new basic game object with container mixin
    When I add several persistent objects to the container "Test" via game object ids
    And I call the load_contents method for container "Test"
    Then each of the persistent objects should have been loaded and stored in container "Test"

  Scenario: test remove method with game object id
    Given a new basic game object with container mixin
    When I add an object to the container "Test" with only the game object id
    Then the contents of the "Test" container should contain the game object id
    When I remove an object from the container "Test" with only the game object id
    Then the object should have been removed from the container "Test"

  Scenario: test add method with contained object
    Given a new basic game object with container mixin
    And a new basic game object with contained mixin
    When I add a contained object to the container "Test"
    Then the contained object should have the correct container