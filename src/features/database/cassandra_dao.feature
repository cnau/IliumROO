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

Feature: database
  As a game I want a database
  So that I can persist data
  
  Scenario: test system log super column family
    Given I have a clean test category for the system log
    When I insert a new log entry
    Then the inserted log entry should not be empty
    And the log entry should be the same as I inserted
    Then I need to clean up the system log
    
  Scenario: test objects column family
    Given I have a clean objects test key
    When I insert a new object
    Then the inserted object should not be empty
    Then I need to clean up the test key

  Scenario: test object tags super column family
    Given I have a clean unit testing tag
    When I insert two new rows
    Then the there should be two rows returned
    And each row should have two columns
    Then I need to clean up the test object tag