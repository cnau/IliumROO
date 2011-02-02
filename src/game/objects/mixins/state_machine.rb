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
require 'logging/logging'

module StateMachine
  include Logging

  attr_accessor :previous_state, :current_state

  def global_state
    @global_state
  end

  def global_state=(arg)
    @global_state = arg.instance
  end

  def update
    @current_state.execute(self)  unless @current_state.nil?
    @global_state.execute(self)   unless @global_state.nil?
  end

  def change_state(new_state)
    raise Exception.new "Attempting to set a nil state" if new_state.nil?

    @previous_state = @current_state
    @current_state.exit(self) unless @current_state.nil?
    @current_state = new_state.instance
    @current_state.enter(self) unless @current_state.nil?
  end

  def revert_to_previous_state
    change_state @previous_state.class
  end

  def in_state?(st)
    st == @current_state.class
  end
end