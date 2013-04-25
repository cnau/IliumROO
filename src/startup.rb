#!/usr/bin/env ruby

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

$: << File.expand_path(File.dirname(__FILE__))

require 'game_objects/game_object_loader'

game = nil

game_id = Game.get_game_id

if game_id.nil?
  if (!GameConfig.instance.config.nil?) && (!GameConfig.instance.config.empty?) && (!GameConfig.instance['startup'].nil?) && (!GameConfig.instance['startup'].empty?)
    game_klass_name = GameConfig.instance['startup']['game']
    game_ports = GameConfig.instance['startup']['ports']
  else
    game_klass_name = 'Game'
    game_ports = '6666'
  end

  # create the game
  game_klass = GameObjectLoader.load_object game_klass_name
  game = game_klass.new
  game.port_list = game_ports
  game.save
else
  # load the game
  game = GameObjectLoader.load_object game_id
end

game.start
