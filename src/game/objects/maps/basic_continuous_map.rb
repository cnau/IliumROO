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

class BasicContinuousMap < BasicGameMap
  VERBS = {:north => nil, :n => {:aliasname => :north}, :south => nil, :s => {:aliasname => :south}, :east => nil, :e => {:aliasname => :east}, :west => nil, :w => {:aliasname => :west}}.freeze
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

  def broadcast_to_location(location, msg)
    @players[*location].each { |player|
      player.send_to_client msg
    }
  end

  def calc_movement_direction(new_location, previous_location, exiting = false)
    # locations are 3 length arrays [x,y,z]
    # north = prev.y < new.y
    # east = prev.x < new.x
    # up = prev.z < new.z

    x_dir = nil
    y_dir = nil
    z_dir = nil

    if previous_location[0] < new_location[0]
      x_dir = (exiting ? 'east' : 'west')
    elsif previous_location[0] > new_location[0]
      x_dir = (exiting ? 'west' : 'east')
    end

    if previous_location[1] < new_location[1]
      y_dir = (exiting ? 'north' : 'south')
    elsif previous_location[1] > new_location[1]
      y_dir = (exiting ? 'south' : 'north')
    end

    if previous_location[2] < new_location[2]
      z_dir = (exiting ? 'up' : 'below')
    elsif previous_location[2] > new_location[2]
      z_dir = (exiting ? 'down' : 'above')
    end

    # assemble the directions
    final_dir = ''
    final_dir = 'the ' unless exiting or !z_dir.nil?
    unless z_dir.nil?
      final_dir << z_dir
    end

    # assemble compass dir
    unless x_dir.nil? and y_dir.nil?
      unless z_dir.nil?
        final_dir << ' and '
      end
      final_dir << y_dir unless y_dir.nil?
      final_dir << x_dir unless x_dir.nil?
    end

    final_dir
  end

  def enter_room(new_player, new_location, previous_location = nil)
    @players[*new_location] ||= []
    msg = nil
    if previous_location.nil?
      msg = "#{new_player.name} has entered the map.\n"
    else
      movement_direction = calc_movement_direction(new_location, previous_location)
      msg = "#{new_player.name} arrives from #{movement_direction}.\n"
    end
    broadcast_to_location new_location, msg
    @players[*new_location] << new_player
    new_player.location = new_location
  end

  def exit_room(player, old_location, new_location)
    @players[*old_location].delete player
    movement_direction = calc_movement_direction(new_location, old_location, true)
    broadcast_to_location old_location, "#{player.name} leaves #{movement_direction}.\n"
  end

  # enter is only called for players
  def enter(player, location = nil)
    @start_location = @start_location.is_a?(String) ? eval(@start_location) : @start_location
    new_location = @start_location
    unless location.nil? then
      new_location = (location.is_a?(String) ? eval(location) : location)
    end

    player.send_to_client "Entering game map #{self.name} at location #{new_location}\n"
    player.map = self.game_object_id
    enter_room player, new_location
    player.save

    log.debug { "#{player} entering map #{self.game_object_id} at #{player.location}" }
  end

  def exit(player)
    location = player.location
    if location.nil?
      @players.each { |loc, entities|
        if entities.include? player
          location = loc
          break
        end
      }
    end

    unless location.nil?
      player.send_to_client "Exiting game map #{self.name} from location #{location}.\n"
      log.debug { "#{player} exiting map #{self.game_object_id} from #{location}" }
      @players[*location].delete player
      broadcast_to_location location, "#{player.name} has exited the map.\n"
    end
  end

  def north(player)
    new_loc = player.location.clone   #strictly a shallow copy here
    new_loc[1] += 1
    move player, player.location, new_loc
  end

  def south(player)
    new_loc = player.location.clone   #strictly a shallow copy here
    new_loc[1] -= 1
    move player, player.location, new_loc
  end

  def east(player)
    new_loc = player.location.clone   #strictly a shallow copy here
    new_loc[0] += 1
    move player, player.location, new_loc
  end

  def west(player)
    new_loc = player.location.clone   #strictly a shallow copy here
    new_loc[0] -= 1
    move player, player.location, new_loc
  end

  def move(player, old_location, new_location)
    exit_room player, old_location, new_location
    enter_room player, new_location, old_location
  end
end