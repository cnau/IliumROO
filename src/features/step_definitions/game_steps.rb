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
#  along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>
$: << File.expand_path(File.dirname(__FILE__) + "/../../")

require "features/step_definitions/spec_helper.rb"
require "game_objects/game_object_loader"
require "game/objects/game"

Given /^a mocked game object in the database$/ do
  obj_hash = {'game_object_id'  => 'game',
              'parent'          => 'Game',
              'port_list'       => '6666'}

GameObjects.expects(:get).with('game').once.returns(obj_hash)
end

When /^I load the game object$/ do
  @the_game = GameObjectLoader.load_object "game"
  @the_game.nil?.should == false
end

Then /^I should get the correct game object$/ do
  @the_game.port_list.should == 6666
  @the_game.is_a?(Game).should == true
end