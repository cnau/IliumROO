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

require 'database/game_objects'
require 'database/system_logging'
require 'game_objects/game_object_loader'
require 'date'
require 'game/objects/mixins/client_wrapper'
require 'game/objects/mixins/container'

class ClientAccount < BasicPersistentGameObject
  include ClientWrapper
  include Container

  PROPERTIES = [:email, :password, :last_login_date, :last_login_ip, :display_type, :account_type].freeze
  attr_accessor :email, :password, :last_login_date, :last_login_ip, :display_type, :account_type

  def initialize
    super
    @display_type ||= 'ANSI'
    @account_type ||= 'normal'
  end

  def save
    super
    GameObjects.add_tag 'accounts', self.email, {'object_id' => self.game_object_id}
  end

  def add_new_character(name)
    new_character = generate_new_character(name)

    # add new character to our collection
    self.add_to_container new_character, :characters, {'name' => name}

    # add the log entry
    SystemLogging.add_log_entry 'created new character', self.game_object_id, new_character
  end

  def remove_character(character_id)
    c_name = get_player_name(character_id)
    remove_from_container character_id, :characters
    SystemLogging.add_log_entry "deleted character #{c_name}", self.game_object_id, character_id
  end

  def name_available?(the_name)
    player_name = GameObjects.get_tag 'player_names', the_name
    player_name.empty?
  end

  def get_player_name(game_object_id)
    char_list = list_container(:characters)
    char_list[game_object_id]['name'] if char_list.has_key?(game_object_id)
  end

  def delete_character(game_object_id)
    c_name = get_player_name game_object_id
    GameObjects.remove game_object_id
    GameObjectLoader.remove_from_cache game_object_id
    GameObjects.remove_tag 'player_names', c_name
    remove_from_container game_object_id, :characters
  end

  def set_last_login(client_ip)
    @last_login_ip = client_ip
    @last_login_date = DateTime.now.strftime
    save

    # add the log entry
    SystemLogging.add_log_entry 'logged in account', self.game_object_id
  end

  def self.get_account_id(email_address)
    account = GameObjects.get_tag 'accounts', email_address
    return nil if account.empty?
    account['object_id']
  end

  def self.create_new_account(email_address, password)
    client_account = ClientAccount.new
    client_account.password = password
    client_account.email = email_address
    client_account.save

    SystemLogging.add_log_entry 'created new account', client_account.game_object_id
    client_account
  end

  def self.get_account(account_object_id)
    GameObjectLoader.load_object account_object_id
  end

  def self.account_count()
    accounts = GameObjects.get_tags 'accounts'
    accounts.length
  end

  def generate_new_character(name)
    # create the new character object

    # first get a new object id
    new_class_id = BasicGameObject.generate_game_object_id

    # build the new class' hash definition
    new_class = {:super => 'BasicNamedObject', :mixins => '', :game_object_id => new_class_id}

    # add some basic mixins for every character
    new_character_mixins = []
    new_character_mixins.push 'ClientWrapper'
    new_character_mixins.push 'Contained'
    new_character_mixins.push 'MapLocation'

    # add admin mixin if appropriate
    new_character_mixins.push 'Admin' if account_type.to_sym == :admin

    # put mixin list into character hash
    new_class[:mixins] = new_character_mixins.join(',')
    GameObjects.save new_class_id, new_class

    # now build the class itself
    new_character_klass = GameObjectLoader.load_object new_class_id

    raise "Unable to create character class C#{new_class_id}" if new_character_klass.nil?

    # create an instance of this new character class and save it
    new_character = new_character_klass.new
    new_character.name = name
    new_character.object_tag = :player_names
    new_character.container = self.game_object_id
    new_character.save

    # returning the game object id only
    new_character.game_object_id
  end

  def characters
    list_container(:characters) if container(:characters).empty?
    container(:characters)
  end
end