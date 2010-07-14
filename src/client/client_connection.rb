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

require 'eventmachine'
require 'logging/logging'
require 'client/client_master'
require 'client/login_wrapper'

class ClientConnection < EventMachine::Connection
  include Logging

  attr_reader :client_ip, :client_port

  @client_listeners

  def initialize
    @client_listeners ||= []
  end

  def add_client_listener(callback)
    @client_listeners.push callback
  end

  def remove_client_listener(callback)
    @client_listeners.delete callback
  end

  def post_init
    log.level = Logger::DEBUG
    @client_port, @client_ip = Socket.unpack_sockaddr_in(get_peername)
    log.debug "accepted client connection from #{@client_ip}"

    # register this client connection
    ClientMaster.register_client self

    # post license blurb
    send_license_blurb

    # attach to login object
    lw = LoginWrapper.new
    lw.attach_client self
    lw.do_login
  end

  def send_license_blurb
    f = File.open('../license_blurb.txt', "r") 
    f.each_line do |line|
      send_data line
    end
    send_data "\n"
  end

  def receive_data(data)
    new_data = data.strip
    @client_listeners.each do |callback|
      callback.call(new_data)
    end
  end

  def unbind
   # remove this client connection
    ClientMaster.remove_client self
  end

  private :send_license_blurb
end