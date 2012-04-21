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

Feature: system logging
  As a game I need to log activity
  So player's can't mess with me

  Scenario: basic system logging
    Given a known number of log entries
    When I insert a log
    Then I should see my log entry
    And I should see one more log entry
    Then I should clean up my test log

   Scenario: multiple object target logging
     Given a start count for system log
     And a clean log entry for "test_source_id_1"
     And a clean log entry for "test_target_id_1"
     And a clean log entry for "test_object_id_1"
     And there are no test log entries for "test_source_id_1"
     When I insert a log entry for "test_source_id_1" and "test_target_id_1" and "test_object_id_1"
     Then make sure a log entry was added for "test_source_id_1"
     And make sure log entries for "test_source_id_1" and "test_target_id_1" and "test_object_id_1" were inserted correctly
     And make sure one log entries for "test_source_id_1" exist
     Then clean up the test log entries for "test_source_id_1" and "test_target_id_1" and "test_object_id_1"
