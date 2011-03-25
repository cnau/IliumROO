#  This file is part of Ilium MUD.
#
#  Ilium MUD is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Ilium MUD is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.


# this class is being taken out of the heirarchy.  not really sure how an "owned" object would work in a MUD

require 'game/objects/basic_game_object'

class BasicOwnedObject < BasicGameObject
  PROPERTIES = [:owner, :group, :mode].freeze
  attr_accessor :owner, :group, :mode

  VERBS = {:chmod => {:prepositions => [:to]}, :setmode => {:prepositions => [:to]}, :getmode => nil, :clearmode => nil}.freeze

  FULL_RIGHTS = 0777
  
  FULL_OWNER  = 0700
  READ_OWNER  = 0400
  WRITE_OWNER = 0200
  EXEC_OWNER  = 0100

  FULL_GROUP  = 0070
  READ_GROUP  = 0040
  WRITE_GROUP = 0020
  EXEC_GROUP  = 0010

  FULL_OTHER  = 0007
  READ_OTHER  = 0004
  WRITE_OTHER = 0002
  EXEC_OTHER  = 0001
  
  DEFAULT_MODE = FULL_OWNER | READ_GROUP | EXEC_GROUP | READ_OTHER | EXEC_OTHER

  def initialize
    super
    @mode = DEFAULT_MODE
  end

  def set_owner(new_owner, new_group)
    @owner = new_owner
    @group = new_group
    @mode = DEFAULT_MODE
  end

  def chmod
    return unless check_mode(:write, @command_args[:caller])

    mode = @command_args[:iobjstr].to_i(8)     #convert to octal number
    if mode == 0
      @command_args[:player].send_to_client "illegal mode.\n"
    elsif mode > FULL_RIGHTS
      @command_args[:player].send_to_client "mode #{"%o" % mode} is illegal.\n"
    else
      @command_args[:player].send_to_client "setting mode for #{@game_object_id} to #{"%o" % mode}\n"
      @mode = mode
    end
  end

  def setmode
    chmod
  end

  def getmode
    if check_mode(:read, @command_args[:caller]) then
      @command_args[:player].send_to_client "mode for #{@game_object_id}: #{"%o" % @mode}\n"
    else
      @command_args[:player].send_to_client "You don't have read access to #{@game_object_id}\n"
    end
  end

  def clearmode
    @command_args[:player].send_to_client "clearing mode for #{@game_object_id}\n"
    @mode = 0
  end

  def check_mode(player, access_type, requestor)
    unless has_access(access_type, requestor)

    end
  end

  def has_access(access_type, requestor)
    multiplier = 0
    if requestor == @owner
      multiplier = 0
    elsif requestor == @group
      multiplier = 1
    else
      multiplier = 2
    end
    access = 0
    if access_type == :read
      access = 04
    elsif access_type == :write
      access = 02
    elsif access_type == :execute
      access = 01
    end

    access_requested = access << (3 * multiplier)

    (@mode & access_requested) == access_requested
  end
end