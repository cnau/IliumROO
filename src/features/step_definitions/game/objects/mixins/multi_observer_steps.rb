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

require_relative '../../../spec_helper'

class BasicObservable
  include MultiObserver
end

Given /^a new observable object$/ do
  @new_observer = BasicObservable.new
end

When /^I add a new observer$/ do
  @fired_event = false
  @new_observer.add_observer(:my_event, self) { @fired_event = true }
  @new_observer.count_observers(:my_event).should eql 1
end

When /^I delete the observer$/ do
  @new_observer.remove_observer :my_event, self
end

Then /^there should be no observers$/ do
  @new_observer.count_observers(:my_event).should eql 0
end

When /^I delete all observers$/ do
  @new_observer.remove_all_observers :my_event
end

When /^I fire the event$/ do
  @new_observer.changed :my_event
  @new_observer.notify :my_event
end

Then /^the event should have been fired$/ do
  @fired_event.should be_true
end

When /^I fire the event without marking it changed$/ do
  @new_observer.notify :my_event
end

Then /^the event should not have been fired$/ do
  @fired_event.should be_false
end

When /^I add a new observer with arguments$/ do
  @data_from_args = nil
  @new_observer.add_observer(:my_event, self) {|args| @data_from_args = args}
end

Then /^the event should have been fired with arguments$/ do
  @data_from_args.should == 'some data'
end

When /^I fire the event with arguments$/ do
  @new_observer.changed :my_event
  @new_observer.notify :my_event, 'some data'
end