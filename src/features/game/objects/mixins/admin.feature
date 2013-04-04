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

Feature: test the admin mixin
  As a multi-user game I have administrative commands
  So I need to test the admin mixin

  Scenario: test list_players verb
    Given a new admin object
    When I mock a player list
    Then the list_players command should return the player list

  Scenario: test list_items verb
    Given a new admin object
    When I mock an item list with nil direct object
    Then the list_items command should return the item list with nil direct object

  Scenario: test list_items verb with direct object string
    Given a new admin object
    When I mock an item list with with a direct object
    Then the list_items command should return the item list with the correct item type

  Scenario: test inspect verb with empty string
    Given a new admin object
    Then the inspect command with dobjstr "" should send to player "Inspect what?"

  Scenario: test inspect verb with self
    Given a new admin object
    When I mock an object hash
    Then the inspect command should display the correct object hash

  Scenario: test inspect verb with object id
    Given a new admin object
    When I mock an object hash
    Then the inspect command should display the correct object hash

  Scenario: test inspect verb with object
    Given a new admin object
    When I mock an object hash with a object instance
    Then the inspect command should display the correct object hash

  Scenario: test inspect verb with non-existent object
    Given a new admin object
    When I mock an object hash with a bogus_id
    Then the inspect command with dobjstr "bogus_id" should send to player "Can't find object bogus_id"