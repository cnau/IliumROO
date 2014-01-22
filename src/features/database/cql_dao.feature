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

Feature: cql database
  As a game I want a database
  So that I can persist data

  Scenario: test initialize and connection with test keyspace
    Given a test keyspace
    And a clean database
    And a new CQLDao object
    Then that dao should be connected to the database
    And the database should be valid
    Then the database should be cleaned up
    And the database should not be valid

  Scenario: test execute method on a test keyspace
    Given a test keyspace
    And a clean database
    And a new CQLDao object
    Then that dao should be connected to the database
    And the database should be valid
    Then create a new table
    And insert a few records
    Then select those records
    And the records should be returned
    Then the database should be cleaned up
    And the database should not be valid