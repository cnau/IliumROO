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
module MultiObserver
  def add_observer(event, observer, &callback)
    begin
      @events ||= {}
      @events[event] ||= {}
      @events[event][observer] = callback

    rescue Exception => ex
      @new_events ||= {}
      @new_events[event] ||= {}
      @new_events[event][observer] = callback

    end
  end

  def remove_observer(event, observer)
    begin
      @events[event].delete observer if defined? @events and @events.has_key? event

    rescue Exception => ex
      @events[event][observer] = nil if defined? @events and @events.has_key? event
    end
  end

  def remove_all_observers(event)
    @events[event] = {} if @events.has_key? event
  end

  def changed(event, state = true)
    @changed ||= {}
    @changed[event] = state
  end

  def changed?(event)
    return @changed[event] if defined? @changed and @changed.has_key? event
    false
  end

  def count_observers(event)
    return @events[event].size if @events.has_key? event
    0
  end

  def notify(event, *args)
    if @events.has_key? event
      if changed?(event)
        @events[event].each do |observer, callback|
          callback.call *args unless callback.nil?
        end

        # delete any removed events
        @events.delete_if { |observer, callback|
          callback.nil?
        }

        @events.deep_merge! @new_events unless @new_events.nil?
        @new_events = nil

        changed event, false
      end
    end
  end
end