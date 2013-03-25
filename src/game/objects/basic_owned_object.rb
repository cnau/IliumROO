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
    return unless check_mode(:write, @caller)

    mode = @iobjstr.to_i(8)     #convert to octal number
    if mode == 0
      @player.send_to_client "illegal mode.\n"
    elsif mode > FULL_RIGHTS
      @player.send_to_client "mode #{"%o" % mode} is illegal.\n"
    else
      @player.send_to_client "setting mode for #@game_object_id to #{"%o" % mode}\n"
      @mode = mode
    end
  end

  def setmode
    chmod
  end

  def getmode
    if check_mode(:read, @caller) then
      @player.send_to_client "mode for #@game_object_id: #{"%o" % @mode}\n"
    else
      @player.send_to_client "You don't have read access to #@game_object_id\n"
    end
  end

  def clearmode
    @player.send_to_client "clearing mode for #@game_object_id\n"
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