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

class StartLoginState
  include Singleton

  def enter(entity)
    entity.email_address = nil
    entity.send_to_client 'Email Address:'
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.match(/^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i)
      entity.email_address = entity.last_client_data
      account_id = ClientAccount.get_account_id entity.email_address

      entity.ctr = 0
      if account_id.nil?
        entity.change_state VerifyEmailState
      else
        entity.account = account_id
        entity.change_state GetPasswordState
      end
    else
      entity.ctr += 1
      entity.send_to_client "Invalid email.\n"
      if entity.ctr >= 3
        entity.change_state LogoutState
      else
        entity.change_state StartLoginState
      end
    end
  end
end