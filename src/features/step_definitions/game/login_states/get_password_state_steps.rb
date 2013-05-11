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

Given /^an instance of GetPasswordState$/ do
  @get_password_state = GetPasswordState.instance
  @get_password_state.should_not be_nil
end

When /^I call the enter method of GetPasswordState$/ do
  new_entity = mock
  new_entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_1 = msg}
  @get_password_state.enter new_entity
end

Then /^I should get appropriate output from GetPasswordState 1$/ do
  @client_msg_1.should eql 'Password:'
end

When /^I call the execute method of GetPasswordState with an invalid password$/ do
  account_hash = {:email            => 'test@test.com',
                  :password         => 'password',
                  :last_login_date  => '',
                  :last_login_ip    => '',
                  :display_type     => 'ANSI',
                  :characters       => '',
                  :account_type     => 'normal',
                  :parent           => 'ClientAccount',
                  :game_object_id   => 'test-client-account-2'}
  GameObjects.expects(:get).with('test-client-account-2').returns(account_hash)
  @ctr = 0
  new_entity = mock
  new_entity.stubs(:account).returns('test-client-account-2')
  new_entity.stubs(:last_client_data).returns('password')
  new_entity.stubs(:ctr).returns(@ctr)
  new_entity.stubs(:ctr=).with(is_a(Integer)) {|ctr| @ctr = ctr}
  new_entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_2 = msg}
  new_entity.expects(:change_state).with(GetPasswordState).once
  @get_password_state.execute new_entity
end

Then /^I should get appropriate output from GetPasswordState 2$/ do
  @ctr.should eql 1
  @client_msg_2.should eql "Invalid password.\n"
end

When /^I call the execute method of GetPasswordState with a valid password$/ do
  @last_login_date = DateTime.now.strftime
  account_hash = {:game_object_id   => 'test-client-account-3',
                  :parent           => 'ClientAccount',
                  :account_type     => 'NORMAL',
                  :last_login_ip    => '127.0.0.2',
                  :last_login_date  => @last_login_date,
                  :password         => Password::update('password'),
                  :email            => 'test@test.com'}

  # setup mock game object to prevent database hit
  GameObjects.expects(:get).with('test-client-account-3').returns(account_hash)
  GameObjects.expects(:save).with('test-client-account-3', is_a(Hash)) {|id, client_hash| @client_hash_3 = client_hash}
  SystemLogging.expects(:add_log_entry).with('logged in account', 'test-client-account-3')
  GameObjects.expects(:add_tag).with('accounts', 'test@test.com', {'object_id' => 'test-client-account-3'})

  new_entity = mock
  @ctr = 0
  new_entity.stubs(:ctr).returns(@ctr)
  new_entity.stubs(:ctr=).with(is_a(Integer)) {|ctr| @ctr = ctr}
  new_entity.stubs(:account).returns('test-client-account-3')
  new_entity.stubs(:last_client_data).returns('password')
  new_entity.expects(:send_to_client).with(is_a(String)) {|msg| @client_msg_3 = msg}

  mock_client = mock
  mock_client.stubs(:client_ip).returns('127.0.0.2')
  mock_client.expects(:add_observer)

  new_entity.stubs(:client).returns(mock_client)
  new_entity.expects(:detach_client).once
  ClientAccount.any_instance.expects(:change_state).with(MainMenuState)
  @get_password_state.execute new_entity
end

Then /^I should get appropriate output from GetPasswordState 3$/ do
  @client_msg_3.should eql "Last login from 127.0.0.2 on #{@last_login_date}\n"
end

Then /^I should get an appropriate client hash for GetPasswordState 3$/ do
  @client_hash_3.should_not be_nil
  @client_hash_3.should have_key :game_object_id
  @client_hash_3[:game_object_id].should eql 'test-client-account-3'
  @client_hash_3.should have_key :email
  @client_hash_3[:email].should eql 'test@test.com'
  @client_hash_3.should have_key :last_login_ip
  @client_hash_3[:last_login_ip].should eql '127.0.0.2'
  @client_hash_3.should have_key :last_login_date
  @client_hash_3[:last_login_date].should eql @last_login_date
end

When /^I call the execute method of GetPasswordState with an invalid password thrice$/ do
  account_hash = {:email            => 'test@test.com',
                  :password         => 'password',
                  :last_login_date  => '',
                  :last_login_ip    => '',
                  :display_type     => 'ANSI',
                  :characters       => '',
                  :account_type     => 'normal',
                  :parent           => 'ClientAccount',
                  :game_object_id   => 'test-client-account-4'}
  GameObjects.expects(:get).with('test-client-account-4').returns(account_hash)
  @ctr = 3
  new_entity = mock
  new_entity.stubs(:account).returns('test-client-account-4')
  new_entity.stubs(:last_client_data).returns('password')
  new_entity.stubs(:ctr).returns(@ctr)
  new_entity.stubs(:ctr=).with(is_a(Integer)) {|ctr| @ctr = ctr}
  new_entity.expects(:change_state).with(LogoutState)
  @get_password_state.execute new_entity
end

Then /^I should get appropriate output from GetPasswordState 4$/ do
  @client_msg_4.should be_nil
end