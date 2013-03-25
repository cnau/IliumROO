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
    @client.add_observer(:client_data, self) { |data|
                                                @last_client_data = data
                                                self.update}
  end

  def send_to_client(message)
    @client.send_data message unless @client.nil?
  end

  def detach_client
    @client.remove_observer :client_data, self
    @client = nil
  end

  def disconnect
    @client.close_connection_after_writing
    detach_client
  end
end