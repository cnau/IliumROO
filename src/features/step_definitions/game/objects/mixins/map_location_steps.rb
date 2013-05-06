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
$: << File.expand_path(File.dirname(__FILE__) + '/../../')

require 'features/step_definitions/spec_helper.rb'
require 'game/objects/mixins/map_location'

class MapLocationTester
  include MapLocation

  def location
    @location
  end
end

Given /^a new object with MapLocation mixin$/ do
  @map_location_obj = MapLocationTester.new
  @map_location_obj.should_not be_nil
  @map_location_obj.is_a?(MapLocation).should be_true
end

When /^I set the location to an object$/ do
  @map_location_obj.location = [0,0,0]
end

Then /^the location should be an object$/ do
  @map_location_obj.location.should eql [0,0,0]
end

When /^I set the location to a string representation of an object$/ do
  @map_location_obj.location = [0,0,0].to_s
end

When /^I set the map property to a string$/ do
  @map_location_obj.map = 'TestMAP'
end

Then /^the map property should be set$/ do
  @map_location_obj.map.should eql 'TestMAP'
end

When /^I set the map property to a basic game object$/ do
  @map_obj = BasicGameObject.new
  @map_location_obj.map = @map_obj
end

Then /^the map property should be set to the object$/ do
  @map_location_obj.map.should_not be_nil
  @map_location_obj.map.should eql @map_obj
end