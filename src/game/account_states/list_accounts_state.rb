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
require 'game/utils/colorizer'
require 'game/account_states/main_menu_state'
require 'game/account_states/view_account_details_state'

class ListAccountsState
  include Singleton
  include Colorizer

  def enter(entity)
    accounts = GameObjects.get_tags 'accounts'

    if accounts.empty?
      entity.change_state MainMenuState
      return
    end

    menu = ''
    ctr = 1
    accounts.each do |account_name, account_hash|
      menu << "[blue]#{ctr}.[white] #{account_name}\n"
      ctr += 1
    end

    menu = colorize(menu, entity.display_type)
    entity.send_to_client menu << 'Choose account (q): '
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.empty?
      entity.change_state MainMenuState
    else
      accounts = GameObjects.get_tags 'accounts'
      idx = entity.last_client_data.to_i
      if idx > 0 and idx <= accounts.count
        entity.change_state ViewAccountDetailsState
      else
        entity.change_state ListAccountsState
      end
    end
  end
end