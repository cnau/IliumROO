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
require 'yaml'

class BasicContinuousMap < BasicGameMap
  VERBS = {:enter => nil}.freeze
  PROPERTIES = [:rooms, :start_location].freeze

  attr_accessor :start_location

  def initialize
    super
    @rooms = SparseMatrix.new
    @start_location = [0,0,0]
  end

  def enter(dobj)
    @rooms[*@start_location] = BasicContinuousRoom.new if @rooms.contains_key? @start_location
    @rooms[*@start_location].enter dobj
    log.debug "#{dobj.game_object_id} entering room #{@start_location}"
  end

  def to_h
    ret = super
    rooms_save = @rooms.inject({}) {|h,(k,v)| h.update({k => v.game_object_id})}
    p "to_h: #{rooms_save}"
    ret[:rooms] = YAML.dump(rooms_save)
    ret
  end
end