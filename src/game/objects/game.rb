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

require 'logging/logging'
require 'eventmachine'
require 'database/game_objects'
require 'client/client_connection'
require 'game/objects/basic_persistent_game_object'

class Game < BasicPersistentGameObject
  include Logging

  attr_accessor :port_list
  PROPERTIES = [:port_list].freeze

  def self.get_game_id
    game_info = GameObjects.get_tag 'startup', 'game'
    return nil if game_info.empty?
    game_info['object_id']
  end

  def save
    super
    GameObjects.add_tag 'startup', 'game', {'object_id' => self.game_object_id}
  end

  def initialize
    super
    log.debug "initializing game object"
    @socket_servers ||= []
  end

  # stops all socket servers
  def stop_socket_servers
    log.debug {"stopping all socket servers"}
    @socket_servers.each do |server|
      server.close_connection
    end
    @socket_servers.clear
  end

  # starts up all socket servers
  def start_socket_servers
    log.debug {"starting socket servers on ports #{@port_list}"}
    @port_list.to_s.split(",").map do |port|
      log.debug {"starting socket server on port #{port}"}
      @socket_servers.push EventMachine.start_server 'localhost', port, ClientConnection
    end
  end

  # starts the game
  def start
    EventMachine.run do
      log.debug {"spinning up socket servers"}
      # startup the socket servers
      start_socket_servers
    end
  end

  private :start_socket_servers, :stop_socket_servers
end