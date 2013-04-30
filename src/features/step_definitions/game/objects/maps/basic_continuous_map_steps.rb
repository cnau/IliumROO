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
require 'game/objects/maps/basic_continuous_map'

Given /^a BasicContinuousMap object$/ do
  @map = BasicContinuousMap.new
end

When /^I save the continuous map$/ do
  GameObjects.expects(:save).with(@map.game_object_id, is_a(Hash)) {|object_id, obj_hash| @map_hash = obj_hash}
  @map.save
end

Then /^I should get a correctly saved continuous map$/ do
  @map.game_object_id.should_not be_nil
  @map_hash.should eql @map.to_h
end

Given /^the map has objects in the world$/ do
  @map.entities.should_not be_nil
  @map.entities[0,0,0] = BasicGameObject.new
end

Then /^the saved map should contain a list of entities$/ do
  @map_hash.should include :entities
  @map_hash[:entities].should_not be_nil

  entities = YAML.load(@map_hash[:entities])
  p "STEP: #{entities}"
  entities.should_not be_empty
  entities.size.should eql 1
  entity = entities[0]
  entity.size.should eql 2
  coords = eval(entity[0])
  coords.should eql [0,0,0]
  entity[1].should eql @map.entities[0,0,0].game_object_id
end