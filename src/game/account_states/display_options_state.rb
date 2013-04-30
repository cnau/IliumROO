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

class DisplayOptionsState
  include Singleton
  include Colorizer

  def enter(entity)
    menu = ''
    if entity.display_type == 'ANSI'
      menu << "[blue]1.[white] turn off ANSI color\n"
    else
      menu << "[blue]1.[white] turn on ANSI color\n"
    end
    menu << '[white]choose and perish:'
    menu = colorize(menu, entity.display_type)

    entity.send_to_client menu
  end

  def exit(entity)
  end

  def execute(entity)
    if entity.last_client_data.empty?
      entity.change_state MainMenuState
    else
      case entity.last_client_data
        when '1'
          if entity.display_type == 'ANSI'
            entity.display_type = 'NONE'
          else
            entity.display_type = 'ANSI'
          end
          entity.save
          entity.change_state MainMenuState
        else
          entity.send_to_client "Invalid choice.\n"
          entity.change_state DisplayOptionsState
      end
    end
  end
end