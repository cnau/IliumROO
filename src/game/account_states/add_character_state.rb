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

class AddCharacterState
  include Singleton
  include Colorizer

  def enter(entity)
    entity.send_to_client "Enter new character's name:"
  end

  def exit(entity)
  end

  def execute(entity)
    name = entity.last_client_data.capitalize
    if name.empty?
      entity.change_state MainMenuState 
    elsif name.match(/^[A-Z][a-z]*$/)
      if entity.name_available? name
        entity.add_new_character name
        entity.send_to_client "Added new character named #{name}.\n"
        entity.change_state MainMenuState
      else
        entity.send_to_client "That name is already taken.\n"
        entity.change_state AddCharacterState
      end
    else
      entity.send_to_client "Invalid character name.  Name should start with a capital letter.\n"
      entity.change_state AddCharacterState
    end
  end
end