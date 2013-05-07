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
require 'game/objects/maps/basic_continuous_map'
require 'logging/logging'

module Startup
  def create_starting_map
    startup_map_hash = GameObjects.get_tag 'startup', 'map'

    if startup_map_hash.nil? or startup_map_hash.empty?
      startup_map_name = nil
      startup_map_room = nil
      if (!GameConfig.instance.config.nil?) && (!GameConfig.instance.config.empty?) && (!GameConfig.instance['startup'].nil?) && (!GameConfig.instance['startup'].empty?)
        startup_map_name = GameConfig.instance['startup']['map']
        startup_map_room = GameConfig.instance['startup']['room']
        if !startup_map_room.nil? and startup_map_room.is_a?(String)
          startup_map_room = eval(startup_map_room)
        end
      end

      startup_map_name ||= 'BasicContinuousMap'

      map_klass = GameObjectLoader.load_object startup_map_name

      startup_map = map_klass.new
      startup_map.start_location = startup_map_room unless startup_map_room.nil? or startup_map_room.empty?
      startup_map.on_load
      startup_map.save

      GameObjects.add_tag 'startup', 'map', {'object_id' => startup_map.to_s}
    end
  end

  def create_new_game
    game_klass_name = nil
    game_ports = nil
    if (!GameConfig.instance.config.nil?) && (!GameConfig.instance.config.empty?) && (!GameConfig.instance['startup'].nil?) && (!GameConfig.instance['startup'].empty?)
      game_klass_name = GameConfig.instance['startup']['game']
      game_ports = GameConfig.instance['startup']['ports']
    end

    game_klass_name ||= 'Game'
    game_ports ||= '6666'

    # create the game
    game_klass = GameObjectLoader.load_object game_klass_name
    $game = game_klass.new
    $game.port_list = game_ports
    $game.save
  end

  def start_game
    Startup::create_starting_map

    $game = nil

    game_id = Game.get_game_id

    if game_id.nil?
      Startup::create_new_game
    else
      # load the game
      $game = GameObjectLoader.load_object game_id
    end

    $game.start
  end

  module_function :start_game, :create_new_game, :create_starting_map
end

Startup::start_game unless $TEST_MODE