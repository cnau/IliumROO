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

module ClientWrapper
  attr_reader :last_client_data, :client

  VERBS = {:quit => nil, :what_am_i? => nil, :list_verbs => nil}

  def quit
    @player.send_to_client "bye.\n"
    save if self.methods.include?(:save)
    disconnect
  end

  def list_verbs
    ret = ""
    verb_list = self.class.verbs
    verb_list.each do |verb,prepositions|
      ret << ', ' if ret.length > 0
      ret << verb.to_s
    end
    @player.send_to_client ret + "\n"
  end

  def what_am_i?
    @player.send_to_client "You are an instance of #{@player.class.name}.\n"
  end
  
  def attach_client(client)
    @client = client
    @client.add_client_listener method(:receive_data)
  end

  def receive_data(data)
    @last_client_data = data
    self.update   # this implies that anything including this module requires StateMachine as well
  end
  
  def send_to_client(message)
    @client.send_data message unless @client.nil?
  end

  def detach_client
    @client.remove_client_listener method(:receive_data)
    @client = nil
  end

  def disconnect
    @client.close_connection_after_writing
    detach_client
  end
end