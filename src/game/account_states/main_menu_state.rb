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
require 'client/client_master'
require 'game/account_states/logout_state'
require 'game/account_states/add_character_state'
require 'game/account_states/delete_character_state'
require 'game/account_states/display_options_state'
require 'game/account_states/enter_world_state'
require 'game/account_states/list_accounts_state'

class MainMenuState
  include Singleton
  include Colorizer

  def enter(entity)
    # build main menu string
    main_menu = ''
    main_menu << "[blue]1.[white] enter world\n"
    main_menu << "[blue]2.[white] add character\n"
    main_menu << "[blue]3.[white] delete character\n"
    main_menu << "[blue]4.[white] set display options\n"
    main_menu << "[blue]5.[white] quit\n"
    main_menu << "[blue]6.[white] list accounts\n" if entity.account_type.to_sym == :admin
    main_menu << '[white]choose and perish:'
    main_menu = colorize(main_menu, entity.display_type)

    entity.send_to_client main_menu
  end

  def exit(entity)
  end

  def execute(entity)
    client_choice = entity.last_client_data.to_i

    case client_choice
      when 1 then
        entity.change_state EnterWorldState

      when 2 then
        entity.change_state AddCharacterState

      when 3 then
        entity.change_state DeleteCharacterState

      when 4 then
        entity.change_state DisplayOptionsState

      when 5 then
        entity.change_state LogoutState

      when 6 then
        if entity.account_type.to_sym == :admin then
          entity.change_state ListAccountsState
        else
          entity.send_to_client "invalid option\n"
          entity.change_state MainMenuState
        end
      else
        entity.send_to_client "invalid option\n"
        entity.change_state MainMenuState
    end
  end
end