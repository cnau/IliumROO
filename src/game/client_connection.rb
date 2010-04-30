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

require 'logging/logging'
require 'game/client_master'
require 'eventmachine'

class ClientConnection < EventMachine::Connection
  include Logging

  def post_init
    log.level = Logger::DEBUG
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    log.debug "accepted client connection from #{ip}"

    # register this client connection
    ClientMaster.register_client self

    # post license blurb
    send_license_blurb
  end

  def send_license_blurb
    f = File.open('../license_blurb.txt', "r") 
    f.each_line do |line|
      send_data line
    end
    send_data "\n"
  end

  def receive_data(data)
    
  end

  def unbind
   # remove this client connection
    ClientMaster.remove_client self
  end
end