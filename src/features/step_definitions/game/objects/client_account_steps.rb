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
$: << File.expand_path(File.dirname(__FILE__) + '/../../')

require 'features/step_definitions/spec_helper.rb'

require 'game_objects/game_object_loader'
require 'game/objects/client_account'

Given /^a new client account object 1$/ do
  @client_account_1 = ClientAccount.new
  @client_account_1.should_not be_nil
  @client_account_1.class.superclass.should eql BasicPersistentGameObject
end

Then /^I have correct properties in the object$/ do
  #attr_accessor :email, :password, :last_login_date, :last_login_ip, :display_type, :characters, :account_type
  client_account_hash = @client_account_1.to_h
  @client_account_1.class.properties.should include :email
  @client_account_1.class.properties.should include :password
  @client_account_1.class.properties.should include :last_login_date
  @client_account_1.class.properties.should include :last_login_ip
  @client_account_1.class.properties.should include :display_type
  @client_account_1.class.properties.should include :characters
  @client_account_1.class.properties.should include :account_type

  @client_account_1.game_object_id.should_not be_nil
  @client_account_1.display_type.should eql 'ANSI'
  @client_account_1.account_type.should eql 'normal'
end

Given /^a new client account object 2$/ do
  @client_account_2 = ClientAccount.new
  @client_account_2.should_not be_nil
end

And /^a mocked client account save call 2$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, obj_hash| @object_hash_2 = obj_hash }
  GameObjects.expects(:add_tag).with('accounts', 'test2@test.com', is_a(Hash)) { |object_tag, email_address, tag_hash| @tag_hash_2 = tag_hash }
end

When /^I set some properties in the ClientAccount object 2$/ do
  @client_account_2.email = 'test2@test.com'
  @client_account_2.password = 'pass'
end

When /^I save the ClientAccount Object 2$/ do
  @client_account_2.save
end

Then /^I should get appropriate values in the client account hash 2$/ do
  #{'object_id' => self.game_object_id}
  @object_hash_2.should have_key :email
  @object_hash_2[:email].should eql 'test2@test.com'

  @object_hash_2.should have_key :password
  @object_hash_2[:password].should eql 'pass'

  @tag_hash_2.should have_key 'object_id'
  @tag_hash_2['object_id'].should eql @client_account_2.game_object_id
end

Given /^a new client account object 3$/ do
  @client_account_3 = ClientAccount.new
  @client_account_3.should_not be_nil
end

Given /^a mocked client account add_new_character call$/ do
  # save new character
  @new_class_hash = {:super => 'BasicNamedObject', :mixins => '', :game_object_id => 'Test'}
  GameObjects.expects(:get).with(is_a(String)).returns(@new_class_hash)

  @save_hash_3 = []
  GameObjects.expects(:save).times(3).with(is_a(String), is_a(Hash)) { |object_id, object_hash| @save_hash_3.push object_hash }

  # account tag
  GameObjects.expects(:add_tag).with('accounts', 'test3@test.com', is_a(Hash)) { |tag_name, email, tag_hash| @tag_hash_3 = tag_hash }

  # object tag new character
  GameObjects.expects(:add_tag).with('player_names', 'test3@test.com', is_a(Hash)) { |object_tag, email, tag_hash| @player_tag_hash_3 = tag_hash }

  # system logging calls
  SystemLogging.expects(:add_log_entry).with('created new character', is_a(String), is_a(String))
end

When /^I set some properties in the ClientAccount object 3$/ do
  @client_account_3.email = 'test3@test.com'
  @client_account_3.password = 'pass'
end

When /^I add a new character$/ do
  @client_account_3.add_new_character 'Test'
end

Then /^I should get appropriate values in the client account hash 3$/ do
  client_hash = @save_hash_3.pop
  new_char_hash = @save_hash_3.pop
  new_class_hash = @save_hash_3.pop

  new_char_hash.should include :game_object_id

  client_hash.should include :characters
  client_hash[:characters].should eql new_char_hash[:game_object_id]

  new_class_hash.should include :super
  new_class_hash[:super].should eql 'BasicNamedObject'
end

Given /^a new client account object 4$/ do
  @client_account_4 = ClientAccount.new
  @client_account_4.should_not be_nil
  @client_account_4.characters = 'NEW_CHAR_1'
  @client_account_4.email = 'test4@test.com'
end

Given /^a mocked client account remove_character database call$/ do
  SystemLogging.expects(:add_log_entry).with('deleted character Test', is_a(String), is_a(String))
  GameObjects.expects(:get).with('NEW_CHAR_1').returns({:name => 'Test'})
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, object_hash| @save_hash_4 = object_hash }
  GameObjects.expects(:add_tag).with('accounts', 'test4@test.com', is_a(Hash)) { |tag_name, email, tag_hash| @tag_hash_3 = tag_hash }
end

When /^I remove a character id$/ do
  @client_account_4.remove_character 'NEW_CHAR_1'
end

Then /^I should have an empty characters hash entry$/ do
  @client_account_4.characters.should be_nil
end

Given /^a new client account object 5$/ do
  @client_account_5 = ClientAccount.new
  @client_account_5.should_not be_nil
end

Given /^a mocked client account name_available call$/ do
  GameObjects.expects(:get_tag).with('player_names', 'Test5').returns('Test5')
end

Then /^I should get correct return from name_available$/ do
  @client_account_5.name_available?('Test5')
end

Given /^a new client account object 6$/ do
  @client_account_6 = ClientAccount.new
  @client_account_6.should_not be_nil
end

Given /^a mocked client account get_player_name call$/ do
  GameObjects.expects(:get).with('TEST_ID_6').returns({:name => 'Test6'})
end

Then /^I should get correct return from get_player_name$/ do
  @client_account_6.get_player_name('TEST_ID_6').should eql 'Test6'
end

Given /^a new client account object 7$/ do
  @client_account_7 = ClientAccount.new
  @client_account_7.should_not be_nil
end

Given /^a mocked client account delete_character call$/ do
  GameObjects.expects(:get).with('TEST_ID_7').returns({:name => 'Test7'})
  GameObjects.expects(:remove).with('TEST_ID_7')
  GameObjectLoader.expects(:remove_from_cache).with('TEST_ID_7')
  GameObjects.expects(:remove_tag).with('player_names', 'Test7')
end

When /^I delete a character$/ do
  @client_account_7.delete_character 'TEST_ID_7'
end

Then /^I should get all the appropriate function calls$/ do
  #NOOP mocha will complain if the mocked calls don't get called
end

Given /^a new client account object 8$/ do
  @client_account_8 = ClientAccount.new
  @client_account_8.should_not be_nil
  @client_account_8.email = 'test8@test.com'
  @client_account_8.password = 'test'
end

Given /^a mocked client account set_last_login call$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, object_hash| @object_hash_8 = object_hash }
  GameObjects.expects(:add_tag).with('accounts', 'test8@test.com', is_a(Hash)) { |object_tag, email_address, tag_hash| @tag_hash_8 = tag_hash }
  SystemLogging.expects(:add_log_entry).with('logged in account', @client_account_8.game_object_id)
end

When /^I call set_last_login$/ do
  @client_account_8.set_last_login '255.255.255.255'
end

Given /^a mocked client account get_account_id call$/ do
  GameObjects.expects(:get_tag).with('accounts', 'test9@test.com').returns({'object_id' => 'test-object-id-9'})
end

When /^I call get_account_id$/ do
  @account_object_id_9 = ClientAccount.get_account_id('test9@test.com')
end

Then /^I should get a correct response$/ do
  @account_object_id_9.should eql 'test-object-id-9'
end

Given /^a mocked create_new_account database call$/ do
  GameObjects.expects(:save).with(is_a(String), is_a(Hash)) { |object_id, object_hash| @object_hash_9 = object_hash }
  GameObjects.expects(:add_tag).with('accounts', 'test9@test.com', is_a(Hash)) { |object_tag, email_address, tag_hash| @tag_hash_9 = tag_hash }
  SystemLogging.expects(:add_log_entry).with('created new account', is_a(String))
end

When /^I call create_new_account$/ do
  ClientAccount.create_new_account 'test9@test.com', 'pass'
end

Then /^I should get correct hashes from create_new_account$/ do
  @object_hash_9.should include :email
  @object_hash_9[:email].should eql 'test9@test.com'
  @object_hash_9.should include :password
  @object_hash_9[:password].should eql 'pass'
  @object_hash_9.should include :game_object_id

  @tag_hash_9.should include 'object_id'
  @tag_hash_9['object_id'].should eql @object_hash_9[:game_object_id]
end

Given /^a mocked get_account database call$/ do
  GameObjects.expects(:get).with('test-object-id-10').returns({:email => 'test10@test.com', :password => 'pass', :last_login_date => '', :last_login_ip => '', :display_type => 'ANSI', :characters => '', :account_type => 'normal', :parent => 'ClientAccount', :game_object_id => 'test-object-id-10'})
end

When /^I call get_account$/ do
  @client_account_10 = ClientAccount.get_account('test-object-id-10')
end

Then /^I should get correct hashes from get_account$/ do
  @client_account_10.should_not be_nil
  @client_account_10.class.should eql ClientAccount

  @client_account_10.email.should eql 'test10@test.com'
  @client_account_10.game_object_id.should eql 'test-object-id-10'
  @client_account_10.password.should eql 'pass'
end

Given /^a mocked account_count database call$/ do
  GameObjects.expects(:get_tags).with('accounts').returns({'test11@test.com' => {'object_id' => 'test-object-id-11'}})
end

When /^I call account_count$/ do
  @account_count_11 = ClientAccount.account_count
end

Then /^I should get a correct account_count count$/ do
  @account_count_11.should eql 1
end

Given /^a new client account object 9$/ do
  @client_account_9 = ClientAccount.new
  @client_account_9.should_not be_nil
  @client_account_9.class.superclass.should eql BasicPersistentGameObject
  @client_account_9.account_type = 'admin'
end

Then /^I should have the correct mixins for the new character class$/ do
  @client_account_9.characters.should_not be_nil
  @client_account_9.characters.split(',').size.should eql 1
  new_char_id = @client_account_9.characters.split(',')[0]
  GameObjects.expects(:get).with(new_char_id).returns(@save_hash_9[0])
  new_char = GameObjectLoader.load_object new_char_id

  new_char.included_modules.should include Admin
  new_char.included_modules.should include ClientWrapper
end

Given /^a mocked client account add_new_character call 9$/ do
  # save new character
  @new_class_hash_9 = {:super => 'BasicNamedObject', :mixins => 'Admin,ClientWrapper', :game_object_id => 'Test'}
  GameObjects.expects(:get).with(is_a(String)).returns(@new_class_hash_9)

  @save_hash_9 = []
  GameObjects.expects(:save).times(3).with(is_a(String), is_a(Hash)) { |object_id, object_hash| @save_hash_9.push object_hash }

  # account tag
  GameObjects.expects(:add_tag).with('accounts', 'test9@test.com', is_a(Hash)) { |tag_name, email, tag_hash| @tag_hash_9 = tag_hash }

  # object tag new character
  GameObjects.expects(:add_tag).with('player_names', 'test9@test.com', is_a(Hash)) { |object_tag, email, tag_hash| @player_tag_hash_9 = tag_hash }

  # system logging calls
  SystemLogging.expects(:add_log_entry).with('created new character', is_a(String), is_a(String))
end

When /^I add a new character 9$/ do
  @client_account_9.add_new_character 'Test'
end