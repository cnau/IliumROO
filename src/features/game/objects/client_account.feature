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

Feature: client account
  As a multi-user game I have clients
  So I need a client account object to manipulate them

  Scenario: test a ClientAccount's constructor
    Given a new client account object 1
    Then I have correct properties in the object

  Scenario: test a ClientAccount's save function
    Given a new client account object 2
    And a mocked client account save call 2
    When I set some properties in the ClientAccount object 2
    And I save the ClientAccount Object 2
    Then I should get appropriate values in the client account hash 2

  Scenario: test a ClientAccount's add_new_character function
    Given a new client account object 3
    And a mocked client account add_new_character call
    When I set some properties in the ClientAccount object 3
    And I add a new character
    Then I should get appropriate values in the client account hash 3

  Scenario: test a ClientAccount's remove_character function
    Given a new client account object 4
    And a mocked client account remove_character database call
    When I remove a character id
    Then I should have an empty characters hash entry

  Scenario: test a ClientAccount's name_available? function
    Given a new client account object 5
    And a mocked client account name_available call
    Then I should get correct return from name_available

  Scenario: test a ClientAccount's get_player_name function
    Given a new client account object 6
    And a mocked client account get_player_name call
    Then I should get correct return from get_player_name

  Scenario: test a ClientAccount's delete_character function
    Given a new client account object 7
    And a mocked client account delete_character call
    When I delete a character
    Then I should get all the appropriate function calls

  Scenario: test a ClientAccount's set_last_login function
    Given a new client account object 8
    And a mocked client account set_last_login call
    When I call set_last_login
    Then I should get all the appropriate function calls

  Scenario: test a ClientAccount's get_account_id static function
    Given a mocked client account get_account_id call
    When I call get_account_id
    Then I should get a correct response

  Scenario: test a ClientAccount's create_new_account static function
    Given a mocked create_new_account database call
    When I call create_new_account
    Then I should get correct hashes from create_new_account

  Scenario: test a ClientAccount's get_account static function
    Given a mocked get_account database call
    When I call get_account
    Then I should get correct hashes from get_account

  Scenario: test a ClientAccount's account_count static function
    Given a mocked account_count database call
    When I call account_count
    Then I should get a correct account_count count