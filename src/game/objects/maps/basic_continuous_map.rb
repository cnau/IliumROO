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

require 'game/objects/maps/basic_game_map'
require 'game/utils/sparse_matrix'
require 'game/objects/mixins/container'
require 'yaml'

class BasicContinuousMap < BasicGameMap
  include Container

  VERBS = {:enter => nil}.freeze
  PROPERTIES = [:start_location].freeze

  attr_accessor :start_location

  def on_load
    log.debug { "Loading map #{self.name} : #{self.game_object_id}" }
  end

  def initialize
    super
    @stationary_entities = SparseMatrix.new
    @mobile_entities = SparseMatrix.new
    @players = SparseMatrix.new
    @start_location ||= [0, 0, 0]
  end

  def enter_room(new_player, new_location, previous_location = nil)
    @players[*new_location] ||= []
    @players[*new_location].each { |player|
      player.send_to_client "#{new_player.name} has entered the map."
    }

    @players[*new_location] << new_player
    new_player.location = new_location
  end

  # enter is only called for players
  def enter(player, location = nil)
    @start_location = @start_location.is_a?(String) ? eval(@start_location) : @start_location
    new_location = (
    if location.nil? then
      @start_location
    else
      location.is_a?(String) ? eval(location) : location
    end
    )

    player.send_to_client "Entering game map #{self.name} at location #{new_location}"
    player.map = self.game_object_id
    enter_room player, new_location
    player.save

    log.debug {"#{player} entering map #{self.game_object_id} at #{player.location}"}
  end
end