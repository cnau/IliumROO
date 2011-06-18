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
require "game/account_states/list_accounts_state"

Given /^an instance of ListAccountsState$/ do
  @list_accounts_state = ListAccountsState.instance
  @list_accounts_state.should_not be_nil
end

Given /^an account list with names of "([^"]*)" and object ids of "([^"]*)"$/ do |names, ids|
  @account_list_hash = {}
  @expected_menu = ""
  unless names.empty?
    names_ar = names.split(",")
    ids_ar = ids.split(",")
    (0..(names_ar.length - 1)).each do |ctr|
      hash = ids_ar[ctr]
      name = names_ar[ctr]
      @account_list_hash[name] = {'object_id' => hash}
      @expected_menu << "#{ctr+1}. #{name}\n"
    end
    @expected_menu << "Choose account (q): "
  end
end

Given /^a mocked entity for ListAccountsState$/ do
  @entity = mock
end

Given /^an entity expecting a change of state for ListAccountsState$/ do
  @entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_state = next_state}
end

When /^I call the enter method of ListAccountsState$/ do
  @list_accounts_state.enter @entity
end

Then /^I should get redirected to "([^"]*)" by ListAccountsState$/ do |next_state|
  @next_state.name.should eql next_state
end

Given /^a mocked GameObjects returning the account list$/ do
  GameObjects.expects(:get_tags).with("accounts").returns(@account_list_hash)
end

Then /^I should get an appropriate menu for ListAccountsState$/ do
  @entity_menu.should eql @expected_menu
end

Given /^an entity expecting to receive a menu for ListAccountsState$/ do
  @entity.expects(:send_to_client).with(is_a(String)) {|entity_menu| @entity_menu = entity_menu}
end

Given /^an entity with display type of "([^"]*)" for ListAccountsState$/ do |display_type|
  @entity.expects(:display_type).returns(display_type)
end

Given /^an entity with last_client_data of "([^"]*)" for ListAccountsState$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
end

When /^I call the execute method of ListAccountsState$/ do
  @list_accounts_state.execute @entity
end
