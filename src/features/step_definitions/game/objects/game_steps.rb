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

require_relative '../../spec_helper'

Given /^a mocked game object in the database$/ do
  obj_hash = {:game_object_id => 'game',
              :parent => 'Game',
              :port_list => '6666'}

  GameObjects.stubs(:get).with('game').returns(obj_hash) {|obj_id| obj_id == 'game'}
end

When /^I load the game object$/ do
  @the_game = GameObjectLoader.load_object 'game'
  @the_game.should_not be_nil
end

Then /^I should get the correct game object$/ do
  @the_game.port_list.should eql 6666
  @the_game.should be_an_instance_of Game
end

Then /^the game should attempt to load the starting map$/ do
  starting_map = mock
  starting_map.expects(:name).once.returns('starting_map')
  GameObjects.expects(:get_tag).once.with('startup', 'map').returns({'object_id' => 'default_map_id'}) { |tag_name, obj_id| tag_name == 'startup' and obj_id == 'map' }
  GameObjectLoader.expects(:load_object).once.with('default_map_id').returns(starting_map)
  @the_game.load_starting_map
end

Then /^the game should not attempt to load an object if there is no starting map$/ do
  GameObjects.expects(:get_tag).once.with('startup', 'map').returns({}) { |tag_name, obj_id| tag_name == 'startup' and obj_id == 'map' }
  @the_game.load_starting_map
end