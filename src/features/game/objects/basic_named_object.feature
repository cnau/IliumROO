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

Feature: named object
  As a game I need to name my objects
  So that players can identify the object

  Scenario: test a named object's constructor
    Given a named game object instance 1
    Then parent should be BasicNamedObject

  Scenario: test a named object's properties
    Given a named game object instance 2
    And a mocked game object save call 2
    When I save it 2
    Then I should have the correct properties in the hash 2
    And I should get an appropriate output message for the user 2

  Scenario: test a named objects name
    Given a named object instance 3
    And a mocked game object save call 3
    When I save it 3
    Then I should have the correct properties in the hash 3
    And I should get an appropriate output message for the user 3

  Scenario: test object tags
    Given a named object instance 4
    And a mocked game object save call 4
    When I save it 4
    Then I should have the correct properties in the hash 4
    And I should get an appropriate output message for the user 4

  Scenario: test object alias
    Given a named object instance 5
    And a mocked game object save call 5
    When I save it 5
    Then I should have the correct properties in the hash 5
    And I should get an appropriate output message for the user 5

  Scenario: test object alias with tag
    Given a named object instance 6
    And a mocked game object save call 6
    When I save it 6
    Then I should have the correct properties in the hash 6
    And I should get an appropriate output message for the user 6

  Scenario: test named object recylcing
    Given a named object instance 7
    And a mocked game object save call 7
    When I save it 7
    And I recycle it
    Then I should have the correct properties in the hash 7
