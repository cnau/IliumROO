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
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>

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