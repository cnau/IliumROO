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
require 'game/objects/mixins/map_location'

class PlayerTester < BasicNamedObject
  include MapLocation
end

Given /^a BasicContinuousMap object$/ do
  @map = BasicContinuousMap.new
  @map.name = 'TestMap'
end

When /^I save the continuous map$/ do
  GameObjects.expects(:save).with(@map.game_object_id, is_a(Hash)) { |obj_id, obj_hash| @map_hash = obj_hash; obj_id == @map.game_object_id }
  @map.save
end

Then /^I should get a correctly saved continuous map$/ do
  @map.game_object_id.should_not be_nil
  @map_hash.should eql @map.to_h
end

When /^a player enters the map$/ do
  GameObjects.expects(:save).once.with(@player.game_object_id, is_a(Hash)) { |obj_id, obj_hash| @player_hash = obj_hash; obj_id == @player.game_object_id }
  @player.expects(:send_to_client).once.with(is_a(String)) { |msg| @player_msg = msg }
  @map.enter @player
end

Then /^the player should have been updated to include his location$/ do
  @player.map.should eql @map.to_s
  @player.location.should eql [0, 0, 0]
end

Then /^the player save hash should include map and location$/ do
  @player_hash.should_not be_nil
  @player_hash.should_not be_empty
  @player_hash.should include :map
  @player_hash[:map].should eql @map.game_object_id

  @player_hash.should include :location
  @player_hash[:location].should eql [0, 0, 0].to_s
end

Given /^a new player object$/ do
  @player = PlayerTester.new
  @player.name = 'First'
end

Then /^the player should have been notified that he entered a map$/ do
  @player_msg.should eql 'Entering game map TestMap at location [0, 0, 0]'
end

Given /^another player in the start location$/ do
  @second_player = PlayerTester.new
  @second_player.name = 'Second'
  GameObjects.expects(:save).once.with(@second_player.game_object_id, is_a(Hash)) { |obj_id, obj_hash| @second_player_hash = obj_hash; obj_id == @second_player.game_object_id }
  @second_player.expects(:send_to_client).twice.with(is_a(String)) { |msg| @second_player_msg = msg }
  @map.enter @second_player
end

Then /^the other player should have been notified too$/ do
  @second_player_msg.should eql 'First has entered the map.'
end