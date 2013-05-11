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

class GetPasswordState
  include Singleton

  def enter(entity)
    entity.send_to_client 'Password:'
  end

  def exit(entity)
  end

  def execute(entity)
    client_account = ClientAccount.get_account entity.account
    if Password::check(entity.last_client_data, client_account.password)
      entity.send_to_client "Last login from #{client_account.last_login_ip} on #{client_account.last_login_date}\n"
      client_account.set_last_login entity.client.client_ip

      client_account.attach_client entity.client
      entity.detach_client
      
      client_account.change_state MainMenuState
    else
      entity.ctr += 1
      if entity.ctr >= 3
        entity.change_state LogoutState
      else
        entity.send_to_client "Invalid password.\n"
        entity.change_state GetPasswordState
      end
    end
  end
end