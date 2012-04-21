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

Feature: test the command parser
  As a game that receives text input from the user
  So I need to parse and understand what the user is requesting

  Scenario: test zero length command
    Given a mocked player object for test one
    When I parse a zero length command
    Then I should receive huh?

  Scenario: test invalid command
    Given a mocked player object for test two
    When I parse an invalid command
    Then I should receive huh?

  Scenario: test one word commands
    Given a mocked player object for test three
    When I parse a one word command
    Then I should get a correct hash

  Scenario: test a one word command with parameters "say hello there!"
    Given a mocked player object for test four
    When I parse a one word command with parameters
    Then I should get a correct hash for test four

  Scenario: test common word replacements " ;, :, " "
    Given a mocked player object for test five
    Given a player object with last_data with a quote
    When I parse a command with common word replacements
    Then I should get a correct hash substitution with verb "say"
    Given a player object with last_data with a colon
    When I parse a command with common word replacements
    Then I should get a correct hash substitution with verb "emote"

  Scenario: test me and here
    Given a mocked player object for test six
    And a player object with last_data "look me" for test six
    When I parse the command
    Then I should get a correct hash for test six

  Scenario: test prepositions
    Given a mocked player object for test seven
    And a player object with last_data "put bag" for test seven
    When I parse the command without prepositions
    Then I should receive huh? for test seven
    Given a player object with last_data "put sock in bag" for test seven
    When I parse the command with prepositions
    Then I should get a correct hash for test seven
    Given a player object with last_data "put sock with bag" for test seven
    When I parse the command with incorrect prepositions
    Then I should receive huh? for test seven

  Scenario: test aliases
    Given a mocked player object for test eight
    And a player object with last_data "put bag" for test eight
    When I parse the command with aliases
    Then I should get a correct hash for test eight

  Scenario: test aliases and prepositions
    Given a mocked player object for test nine
    And a player object with last_data "put sword in bag" for test nine
    When I parse the command with aliases and prepositions
    Then I should get a correct hash for test nine