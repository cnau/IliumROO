#  This file is part of Ilium MUD.
#
#  Ilium MUD is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Ilium MUD is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.

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
