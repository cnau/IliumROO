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