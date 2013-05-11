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

Given /^a new client account object$/ do
  @client_account = ClientAccount.new
  @client_account.should_not be_nil
  @client_account.class.superclass.should eql BasicPersistentGameObject
end

Then /^I have correct properties in the object$/ do
  #attr_accessor :email, :password, :last_login_date, :last_login_ip, :display_type, :characters, :account_type
  client_account_hash = @client_account.to_h
  @client_account.class.properties.should include :email
  @client_account.class.properties.should include :password
  @client_account.class.properties.should include :last_login_date
  @client_account.class.properties.should include :last_login_ip
  @client_account.class.properties.should include :display_type
  @client_account.class.properties.should include :account_type

  @client_account.game_object_id.should_not be_nil
  @client_account.display_type.should eql 'ANSI'
  @client_account.account_type.should eql 'normal'
end

And /^a mocked client account save call$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, obj_hash| @object_hash = obj_hash }
  GameObjects.expects(:add_tag).with('accounts', @client_account.email, is_a(Hash)) { |object_tag, email_address, tag_hash| @tag_hash = tag_hash }
end

When /^I set some properties in the ClientAccount object$/ do
  @client_account.email = 'test@test.com'
  @client_account.password = 'pass'
end

When /^I save the ClientAccount Object$/ do
  @client_account.save
end

Then /^I should get appropriate values in the client account hash$/ do
  #{'object_id' => self.game_object_id}
  @object_hash.should have_key :email
  @object_hash[:email].should eql @client_account.email

  @object_hash.should have_key :password
  @object_hash[:password].should eql @client_account.password

  @tag_hash.should have_key 'object_id'
  @tag_hash['object_id'].should eql @client_account.game_object_id
end

Given /^a mocked client account add_new_character call with name "([^"]*)"$/ do |char_name|
  # save new character
  @new_class_hash = {:super => 'BasicNamedObject', :mixins => 'Contained', :game_object_id => char_name.downcase, :name => char_name}
  GameObjects.expects(:get).with(is_a(String)).returns(@new_class_hash)

  @save_hash = []
  GameObjects.expects(:save).twice.with(is_a(String), is_a(Hash)) { |object_id, object_hash| @save_hash.push object_hash }

  # object tag new character
  GameObjects.expects(:add_tag).once.with('player_names', 'Test', is_a(Hash)) { |tag_name, name, tag_hash| @player_tag_hash = tag_hash; tag_name == 'player_names' and name == 'Test'}

  # system logging calls
  SystemLogging.expects(:add_log_entry).once.with('created new character', @client_account.game_object_id, is_a(String)) {|log_msg, client_obj_id, character_id| @character_id = character_id;log_msg == 'created new character' and client_obj_id == @client_account.game_object_id}

  # container calls
  GameObjects.expects(:add_tag).once.with("#{@client_account.game_object_id}_characters", is_a(String), is_a(Hash)) {|tag_name, obj_id, tag_hash| @char_tag_hash = tag_hash;tag_name == "#{@client_account.game_object_id}_characters" and tag_hash['object_id'] == obj_id}

  # contained calls
  GameObjects.expects(:add_tag).with('contained', is_a(String), is_a(Hash)) {|container, contained_id, tag_hash| container == 'contained'}
end

When /^I add a new character$/ do
  @client_account.add_new_character 'Test'
end

Then /^I should get appropriate values in the client account hash 3$/ do
  new_char_hash = @save_hash.pop
  new_class_hash = @save_hash.pop

  new_char_hash.should include :game_object_id

  new_class_hash.should include :super
  new_class_hash[:super].should eql 'BasicNamedObject'
end

Then /^I should see the character in the account's character list$/ do
  GameObjects.expects(:get_tags).once.with("#{@client_account.game_object_id}_characters").returns({@character_id => @char_tag_hash})
  @client_account.container(:characters).should_not be_nil
  @client_account.container(:characters).should have_key @character_id

  char_list = @client_account.list_container(:characters)
  char_list.should_not be_nil
  char_list.should have_key @character_id
  char_list[@character_id]['name'].should eql 'Test'
end

Given /^a mocked client account get character list call$/ do
  GameObjects.expects(:get_tags).times(2).with("#{@client_account.game_object_id}_characters").returns({'new_char_id' => {'object_id' => 'new_char_id', 'name' => 'remove_char_test'}})
end

When /^I remove a character id$/ do
  @client_account.list_container(:characters)
  @client_account.characters.should_not be_empty

  SystemLogging.expects(:add_log_entry).once.with('deleted character remove_char_test', is_a(String), is_a(String)) {|msg, client_id, ch_id| msg == 'deleted character remove_char_test' and ch_id == 'new_char_id' and client_id == @client_account.game_object_id}
  GameObjects.expects(:remove_tag).once.with("#{@client_account.game_object_id}_characters", is_a(String)) {|tag_name, obj_id| tag_name == "#{@client_account.game_object_id}_characters"}
  GameObjects.expects(:remove_tag).once.with('contained', 'new_char_id') {|tag_name, obj_id| tag_name == 'contained' and obj_id == 'new_char_id'}

  @client_account.remove_character 'new_char_id'
end

Then /^I should have an empty characters hash entry$/ do
  GameObjects.expects(:get_tags).once.with("#{@client_account.game_object_id}_characters").returns({})
  @client_account.characters.should be_empty
end

Given /^a mocked client account name_available call$/ do
  GameObjects.expects(:get_tag).with('player_names', 'Test5').returns('Test5')
end

Then /^I should get correct return from name_available$/ do
  @client_account.name_available?('Test5')
end

Given /^a mocked client account get_player_name call$/ do
  GameObjects.expects(:get_tags).once.with("#{@client_account.game_object_id}_characters").returns({'TEST_ID' => {'object_id' => 'TEST_ID', 'name' => 'Test'}}) {|tag_name| tag_name == "#{@client_account.game_object_id}_characters"}
end

Then /^I should get correct return from get_player_name$/ do
  @client_account.get_player_name('TEST_ID').should eql 'Test'
end

Given /^a mocked client account delete_character call$/ do
  GameObjects.expects(:get_tags).once.with("#{@client_account.game_object_id}_characters").returns({'TEST_ID' => {'object_id' => 'TEST_ID', 'name' => 'Test'}}) {|tag_name| tag_name == "#{@client_account.game_object_id}_characters"}
  GameObjects.expects(:remove_tag).once.with("#{@client_account.game_object_id}_characters", 'TEST_ID') {|tag_name, obj_id| tag_name == "#{@client_account.game_object_id}_characters" and obj_id == 'TEST_ID'}
  GameObjects.expects(:remove).once.with('TEST_ID') {|obj_id| obj_id == 'TEST_ID'}
  GameObjectLoader.expects(:remove_from_cache).with('TEST_ID') {|obj_id| obj_id == 'TEST_ID'}
  GameObjects.expects(:remove_tag).with('player_names', 'Test') {|tag_name, obj_id| tag_name == 'player_names' and obj_id == 'Test'}
  GameObjects.expects(:remove_tag).once.with('contained', 'TEST_ID') {|tag_name, obj_id| tag_name == 'contained' and obj_id == 'TEST_ID'}
end

When /^I delete a character$/ do
  @client_account.delete_character 'TEST_ID'
end

Then /^I should get all the appropriate function calls$/ do
  #NOOP mocha will complain if the mocked calls don't get called
end

Given /^a mocked client account set_last_login call$/ do
  GameObjects.expects(:save).once.with(is_a(String), is_a(Hash)) { |object_id, object_hash| @object_hash = object_hash }
  GameObjects.expects(:add_tag).once.with('accounts', 'test8@test.com', is_a(Hash)) { |object_tag, email_address, tag_hash| @tag_hash = tag_hash }
  SystemLogging.expects(:add_log_entry).once.with('logged in account', @client_account.game_object_id)
end

When /^I call set_last_login$/ do
  @client_account.set_last_login '255.255.255.255'
end

Given /^a mocked client account get_account_id call$/ do
  GameObjects.expects(:get_tag).with('accounts', 'test9@test.com').returns({'object_id' => 'test-object-id-9'})
end

When /^I call get_account_id$/ do
  @account_object_id = ClientAccount.get_account_id('test9@test.com')
end

Then /^I should get a correct response$/ do
  @account_object_id.should eql 'test-object-id-9'
end

Given /^a mocked create_new_account database call$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, object_hash| @object_hash = object_hash }
  GameObjects.expects(:add_tag).with('accounts', 'test9@test.com', is_a(Hash)) { |object_tag, email_address, tag_hash| @tag_hash = tag_hash }
  SystemLogging.expects(:add_log_entry).with('created new account', is_a(String))
end

When /^I call create_new_account$/ do
  ClientAccount.create_new_account 'test9@test.com', 'pass'
end

Then /^I should get correct hashes from create_new_account$/ do
  @object_hash.should include :email
  @object_hash[:email].should eql 'test9@test.com'
  @object_hash.should include :password
  @object_hash[:password].should eql 'pass'
  @object_hash.should include :game_object_id

  @tag_hash.should include 'object_id'
  @tag_hash['object_id'].should eql @object_hash[:game_object_id]
end

Given /^a mocked get_account database call$/ do
  GameObjects.expects(:get).with('test-object-id-10').returns({:email => 'test10@test.com', :password => 'pass', :last_login_date => '', :last_login_ip => '', :display_type => 'ANSI', :characters => '', :account_type => 'normal', :parent => 'ClientAccount', :game_object_id => 'test-object-id-10'})
end

When /^I call get_account$/ do
  @client_account = ClientAccount.get_account('test-object-id-10')
end

Then /^I should get correct hashes from get_account$/ do
  @client_account.should_not be_nil
  @client_account.class.should eql ClientAccount

  @client_account.email.should eql 'test10@test.com'
  @client_account.game_object_id.should eql 'test-object-id-10'
  @client_account.password.should eql 'pass'
end

Given /^a mocked account_count database call$/ do
  GameObjects.expects(:get_tags).with('accounts').returns({'test11@test.com' => {'object_id' => 'test-object-id-11'}})
end

When /^I call account_count$/ do
  @account_count = ClientAccount.account_count
end

Then /^I should get a correct account_count count$/ do
  @account_count.should eql 1
end

Then /^I should have the correct mixins for the new character class$/ do
  @class_hash = @save_hash.pop
  @char_hash = @save_hash.pop

  @char_hash.should_not be_nil
  @char_hash.should_not be_empty
  @char_hash.should have_key :mixins
  @char_hash[:mixins].should include 'Admin'
  @char_hash[:mixins].should include 'ClientWrapper'
end

Given /^that client account is an admin account$/ do
  @client_account.class.superclass.should eql BasicPersistentGameObject
  @client_account.account_type = 'admin'
end