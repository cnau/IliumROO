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

class DeleteCharacterState
  include Singleton
  include Colorizer

  def enter(entity)
    if entity.characters.nil?
      entity.change_state MainMenuState
      return
    end

    del_menu = ''
    ctr = 1
    c_list = entity.characters.split(',')
    c_list.each do |character_id|
      character_name = entity.get_player_name(character_id)
      del_menu << "[blue]#{ctr}.[white] #{character_name}\n"
      ctr += 1
    end

    del_menu = colorize(del_menu, entity.display_type)
    entity.send_to_client del_menu << 'Choose a character to delete: '
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.empty?
      entity.change_state MainMenuState
    else
      c_idx = entity.last_client_data.to_i
      c_list = entity.characters.split(',')
      if (c_idx >= 1) and (c_idx <= c_list.length)
        entity.remove_character c_list[c_idx - 1]
        c_name = entity.get_player_name(c_list[c_idx - 1])
        entity.delete_character c_list[c_idx - 1]
        entity.send_to_client "Deleted #{c_name}.\n"
        entity.change_state MainMenuState
      else
        entity.change_state DeleteCharacterState
      end
    end
  end
end