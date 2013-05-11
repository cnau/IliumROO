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
    raise Exception.new 'Attempting to set a nil state' if new_state.nil?

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