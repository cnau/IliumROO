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

class ClientAccount < BasicPersistentGameObject
  PROPERTIES = [:email, :password, :last_login_date, :last_login_ip, :display_type, :characters, :account_type].freeze
  attr_accessor :email, :password, :last_login_date, :last_login_ip, :display_type, :characters, :account_type

  def initialize
    super
    @display_type ||= "ANSI"
    @account_type ||= "normal"
  end

  def save
    super
    GameObjects.add_tag 'accounts', self.email, {'object_id' => self.game_object_id}
  end

  def add_new_character(name)
    new_character = generate_new_character(name)

    # add new character to our collection
    c_list ||= []
    c_list = @characters.split(',') unless @characters.nil?
    c_list.push new_character
    @characters = c_list.join(',')
    save

    # add the log entry
    SystemLogging.add_log_entry "created new character", self.game_object_id, new_character
  end

  def remove_character(character_id)
    c_list = @characters.split(",")
    c_name = get_player_name(character_id)
    SystemLogging.add_log_entry "deleted character #{c_name}", self.game_object_id, character_id
    c_list.delete character_id
    @characters = c_list.join(",")
    @characters = nil if @characters.empty?
    save
  end

  def name_available?(the_name)
    player_name = GameObjects.get_tag 'player_names', the_name
    player_name.empty?
  end

  def get_player_name(game_object_id)
    player_hash = GameObjects.get game_object_id
    player_hash[:name]
  end

  def delete_character(game_object_id)
    c_name = get_player_name game_object_id
    GameObjects.remove game_object_id
    GameObjectLoader.remove_from_cache game_object_id
    GameObjects.remove_tag 'player_names', c_name
  end
  
  def set_last_login(client_ip)
    @last_login_ip = client_ip
    @last_login_date = DateTime.now.strftime
    save

    # add the log entry
    SystemLogging.add_log_entry "logged in account", self.game_object_id
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

    SystemLogging.add_log_entry "created new account", client_account.game_object_id
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
    new_class_id = UUID.new.to_guid.to_s
    new_class = {:super => 'BasicNamedObject', :mixins => '', :game_object_id => new_class_id}
    new_class[:mixins] << 'Admin' if account_type == :admin
    GameObjects.save new_class_id, new_class
    new_character_klass = GameObjectLoader.load_object new_class_id
    raise "Unable to create character class C#{new_class_id}" if new_character_klass.nil?
    new_character = new_character_klass.new
    new_character.name = name
    new_character.object_tag = :player_names
    new_character.save

    new_character.game_object_id
  end
end