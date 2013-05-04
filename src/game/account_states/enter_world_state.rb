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
require 'game_objects/game_object_loader'
require 'game/player_states/player_prompt_state'

class EnterWorldState
  include Singleton
  include Colorizer

  def enter(entity)
    if entity.characters.empty?
      entity.change_state MainMenuState
      return
    end

    enter_menu = ''
    ctr = 1
    entity.characters.each do |char_id, char_hash|
      enter_menu << "[blue]#{ctr}.[white] #{char_hash['name']}\n"
      ctr += 1
    end

    enter_menu = colorize(enter_menu, entity.display_type)
    entity.send_to_client enter_menu << 'Choose a character to play: '
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.empty?
      entity.change_state MainMenuState
    else
      c_idx = entity.last_client_data.to_i
      c_list = entity.characters
      the_char_id = nil
      if (c_idx >= 1) and (c_idx <= c_list.size)
        # attach client to a player character game object
        ctr = 1
        c_list.each {|char_id, char_hash|
          if ctr == c_idx
            the_char_id = char_hash['object_id']
            break
          end
          ctr += 1
        }
        p_char = GameObjectLoader.load_object the_char_id

        p_char.attach_client entity.client
        entity.detach_client

        #unless p_char.map.nil?
        #  p_map = GameObjectLoader.load_object p_char.map
        #  p_map.insert_character p_char
        #end

        p_char.change_state PlayerPromptState

      else
        entity.change_state EnterWorldState
      end
    end
  end
end