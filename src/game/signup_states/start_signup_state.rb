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

require 'singleton'
require 'game/signup_states/start_signup_state'
require 'game/account_states/main_menu_state'
require 'game/objects/client_account'
require 'game/utils/password'

class StartSignupState  
  include Singleton

  def enter(entity)
    entity.send_to_client "Give me a password for #{entity.email_address}:"
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.length == 0
      entity.send_to_client 'Invalid password.  Please try again.'
      entity.change_state StartSignupState
      
    else
      client_account = ClientAccount.create_new_account entity.email_address, Password::update(entity.last_client_data)
      client_account.set_last_login entity.client.client_ip
      
      client_account.attach_client entity.client
      entity.detach_client

      if ClientAccount.account_count == 1
        client_account.send_to_client "This is the first account created in this database.  Setting account as admin.\n"
        client_account.account_type = 'admin'
        client_account.save
      end
      
      client_account.change_state MainMenuState
    end
  end
end