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
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"
require "game/utils/password"

Given /^a password of "([^"]*)"$/ do |password|
  @password = password
end

When /^I hash the password$/ do
  @hashed_password = Password::update(@password)
  @hashed_password.should_not be_empty
end

Then /^I should be able to validate the password "([^"]*)" against the hash$/ do |password|
  Password.check(password, @hashed_password).should be_true
end

Then /^I should not be able to validate the password "([^"]*)" against the hash$/ do |password|
  Password.check(password, @hashed_password).should be_false
end