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

Feature: test password module
  As a multi user game, I need to hash my user's password
  So let's test the password module


  Scenario: test a one-way hash of a user's password
    Given a password of "password"
    When I hash the password
    Then I should be able to validate the password "password" against the hash

  Scenario: test a one-way hash of a user's password
    Given a password of "password"
    When I hash the password
    Then I should not be able to validate the password "what" against the hash