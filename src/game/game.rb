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

require 'database/game_objects'
require 'game_objects/basic_persistent_game_object'
require 'game/maps/universe'
require 'logging/logging'
require 'game/client_connection'
require 'eventmachine'

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