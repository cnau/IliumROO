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
require "game/account_states/view_account_details_state"

Given /^an instance of ViewAccountDetailsState$/ do
  @view_account_details_state = ViewAccountDetailsState.instance
  @view_account_details_state.should_not be_nil
end

When /^I call the execute method of ViewAccountDetailsState$/ do
  @view_account_details_state.execute @entity
end

Then /^I should get redirected to "([^"]*)" by ViewAccountDetailsState$/ do |next_state|
  @next_state.name.should eql next_state
end

Given /^a mocked entity for ViewAccountDetailsState$/ do
  @entity = mock
end

Given /^an entity expecting a change of state for ViewAccountDetailsState$/ do
  @entity.expects(:change_state).with(is_a(Class)) {|next_state| @next_state = next_state}
end

When /^I call the enter method of ViewAccountDetailsState$/ do
  @view_account_details_state.enter @entity
end

Given /^an account list with names of "([^"]*)" and object ids of "([^"]*)" for ViewAccountDetailsState$/ do |names, ids|
  @account_list_hash = {}
  unless names.empty?
    names_ar = names.split(",")
    ids_ar = ids.split(",")
    (0..(names_ar.length - 1)).each do |ctr|
      hash = ids_ar[ctr]
      name = names_ar[ctr]
      @account_list_hash[name] = {'object_id' => hash}
    end
  end
end

Given /^a mocked GameObjects returning the account list for ViewAccountDetailsState$/ do
  GameObjects.expects(:get_tags).with("accounts").returns(@account_list_hash)
end

Given /^an entity with last_client_data of "([^"]*)" for ViewAccountDetailsState$/ do |last_client_data|
  @entity.stubs(:last_client_data).returns(last_client_data)
end

Then /^I should get an appropriate output message for ViewAccountDetailsState$/ do
  @client_msg.should eql @expected_menu
end

Given /^a mocked client account get_account call with account id of "([^"]*)" for ViewAccountDetailsState$/ do |account_id|
  @client_account = mock
  @client_account.stubs(:email).returns("test@test.com")
  @client_account.stubs(:last_login_date).returns(DateTime.now.strftime)
  @client_account.stubs(:last_login_ip).returns("127.0.0.1")
  @client_account.stubs(:display_type).returns("NONE")
  @client_account.stubs(:account_type).returns("NORMAL")

  @expected_menu = "Account name: #{@client_account.email}\n"
  @expected_menu << "Last login date: #{@client_account.last_login_date}\n"
  @expected_menu << "Last login IP: #{@client_account.last_login_ip}\n"
  @expected_menu << "Display type: #{@client_account.display_type}\n"
  @expected_menu << "Account type: #{@client_account.account_type}\n"
  @expected_menu << "Press enter when done:"

  ClientAccount.expects(:get_account).with(account_id).returns(@client_account)
end

Given /^an entity expecting to receive a menu for ViewAccountDetailsState$/ do
  @entity.expects(:send_to_client).with(is_a(String)) {|client_msg| @client_msg = client_msg}
end

Given /^an entity with display type of "([^"]*)" for ViewAccountDetailsState$/ do |display_type|
  @entity.stubs(:display_type).returns(display_type)
end