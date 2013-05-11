=begin
Copyright (c) 2009-2012 Christian Nau

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

require_relative '../../spec_helper'

Given /^an instance of ListAccountsState$/ do
  @list_accounts_state = ListAccountsState.instance
  @list_accounts_state.should_not be_nil
end

Given /^an account list with names of "([^"]*)" and object ids of "([^"]*)"$/ do |names, ids|
  @account_list_hash = {}
  @expected_menu = ''
  unless names.empty?
    names_ar = names.split(',')
    ids_ar = ids.split(',')
    (0..(names_ar.length - 1)).each do |ctr|
      hash = ids_ar[ctr]
      name = names_ar[ctr]
      @account_list_hash[name] = {'object_id' => hash}
      @expected_menu << "#{ctr+1}. #{name}\n"
    end
    @expected_menu << 'Choose account (q): '
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
  GameObjects.expects(:get_tags).with('accounts').returns(@account_list_hash)
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
