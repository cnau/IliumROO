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

class DeleteCharacterState
  include Singleton
  include Colorizer

  def enter(entity)
    if entity.characters.empty?
      entity.change_state MainMenuState
      return
    end

    del_menu = ''
    ctr = 1
    entity.characters.each do |char_id, char_hash|
      del_menu << "[blue]#{ctr}.[white] #{char_hash['name']}\n"
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
      c_list = entity.characters
      if (c_idx >= 1) and (c_idx <= c_list.size)
        ctr = 1
        the_char_hash = nil
        c_list.each {|char_id, char_hash|
          if ctr == c_idx
            the_char_hash = char_hash
            break
          end
          ctr += 1
        }
        entity.remove_character the_char_hash['object_id']
        entity.delete_character the_char_hash['object_id']
        entity.send_to_client "Deleted #{the_char_hash['name']}.\n"
        entity.change_state MainMenuState
      else
        entity.change_state DeleteCharacterState
      end
    end
  end
end