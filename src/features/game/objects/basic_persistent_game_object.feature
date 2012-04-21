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

Feature: persistent game object
  As a game I need to persist my objects
  So that the game maintains state

  Scenario: test persistent game object constructor
    Given a persistent game object instance
    Then parent should be BasicPersistentGameObject

  Scenario: create a new persistent game object class
    Given a mocked persistent class
    When I request the persistent class
    Then I get the correct class object

  Scenario: create a new persistent object instance
    Given a mocked persistent object
    When I request a new persistent object
    Then I get the correct persistent object

  Scenario: save a new persistent object instance
    Given a mocked persistent object to save
    And a mocked save database function
    When I load a persistent object instance
    And I save a persistent object instance
    Then the object should save

  Scenario: create a new instance of a game object class
    Given a mocked persistent class 2
    When I load a persistent class 2
    And I create an object instance from persistent class 2
    And I change some properties in persistent object
    Given a mocked save function 2
    Then I save the persistent object 2
    Then the object should save 2

  Scenario: test recycling of persistent game object
    Given a mocked persistent object 3
    And a mocked recycle database function 3
    When I load a persistent object instance 3
    And I recycle a persistent object instance 3
    Then the object should recycle