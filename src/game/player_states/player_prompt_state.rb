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
require 'game/objects/mixins/command_parser'
require 'logging/logging'

class PlayerPromptState
  include Singleton
  include Colorizer
  include CommandParser
  include Logging

  def enter(entity)
    entity.send_to_client "\ncommand prompt > "
  end

  def exit(entity)
  end

  def execute(entity)
    begin
      process_command entity

    rescue Exception => ex
      entity.send_to_client "Whoah Nelly!  You broke something, hoss.  #{ex.message}" unless entity.nil?
      log.error { "Unexpected exception running command #{entity.last_client_data} for player #{entity.game_object_id}" }
      log.error ex
    end
    entity.change_state PlayerPromptState unless entity.client.nil?
  end
end