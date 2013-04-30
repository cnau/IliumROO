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
require 'game/objects/maps/basic_game_map'

Given /^a BasicGameMap object$/ do
  @new_map = BasicGameMap.new
  @new_map.name = 'test_map'
end

When /^I save the map$/ do
  GameObjects.expects(:save).with(@new_map.game_object_id, is_a(Hash)) {|object_id, obj_hash| @map_hash = obj_hash}
  GameObjects.expects(:add_tag).with('maps', 'test_map', is_a(Hash)) {|obj_tag, obj_name, tag_hash| @tag_hash = tag_hash}
  @new_map.save
end

Then /^I should get a correctly saved map$/ do
  @map_hash.should eql @new_map.to_h
  @tag_hash.should_not be_nil
  @tag_hash.should include 'object_id'
  @tag_hash['object_id'].should eql @new_map.game_object_id
end