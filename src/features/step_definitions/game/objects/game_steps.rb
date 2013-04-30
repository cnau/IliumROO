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
require 'game_objects/game_object_loader'
require 'game/objects/game'

Given /^a mocked game object in the database$/ do
  obj_hash = {:game_object_id   => 'game',
              :parent           => 'Game',
              :port_list        => '6666'}

GameObjects.expects(:get).with('game').once.returns(obj_hash)
end

When /^I load the game object$/ do
  @the_game = GameObjectLoader.load_object 'game'
  @the_game.should_not be_nil
end

Then /^I should get the correct game object$/ do
  @the_game.port_list.should eql 6666
  @the_game.should be_an_instance_of Game
end