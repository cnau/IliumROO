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

Feature: game objects
  As a game I need objects
  So that there will be something in the world

  Scenario: basic objects
    Given a test keyspace
    And a clean database
    And a new CQLDao object
    Then that dao should be connected to the database
    And the database should be valid
    Given a new game objects object
    Then that game objects object should be valid

    When I insert an object hash
    Then I expect that the object hash was inserted

    Then the database should be cleaned up
    And the database should not be valid

  Scenario: different columns
    Given a test keyspace
    And a clean database
    And a new CQLDao object
    Then that dao should be connected to the database
    And the database should be valid
    Given a new game objects object
    Then that game objects object should be valid

    When I insert an object hash
    And I insert an object hash with different columns
    Then I expect that the object hash was inserted and is identical

    Then the database should be cleaned up
    And the database should not be valid

  Scenario: object tags
    Given a clean tag for object "1"
    And a clean tag for object "2"
    When I insert a new tag for object "1"
    When I insert a new tag for object "2"
    Then I expect object "1" to be inserted
    Then I expect object "2" to be inserted
    And I expect both objects to be inserted
    Then that I clean up object "1"
    Then that I clean up object "2"
