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

Given /^a BasicContinuousMap object$/ do
  @map = BasicContinuousMap.new
  @map.name = 'TestMap'
end

When /^I save the continuous map$/ do
  GameObjects.expects(:save).with(@map.game_object_id, is_a(Hash)) { |obj_id, obj_hash| @map_hash = obj_hash; obj_id == @map.game_object_id }
  GameObjects.expects(:add_tag).with('maps', @map.name, is_a(Hash)) {|tag_name, obj_id, tag_hash| tag_name == 'maps' and obj_id == @map.name}
  @map.save
end

Then /^I should get a correctly saved continuous map$/ do
  @map.game_object_id.should_not be_nil
  @map_hash.should eql @map.to_h
end

When /^a player enters the map$/ do
  @player.expects(:send_to_client).once.with(is_a(String)) { |msg| @player_msg = msg }
  @player.expects(:location=).once.with(is_a(Array)) {|location_array| @player_location = location_array}
  @player.expects(:map=).once.with(@map.game_object_id) {|obj_id| obj_id == @map.game_object_id; @player_map = obj_id}
  @player.expects(:save).once
  @player.expects(:location).once.returns([0,0,0])
  @map.enter @player
end

Then /^the player should have been updated to include his location$/ do
  @player_map.should eql @map.to_s
  @player_location.should eql [0, 0, 0]
end

Given /^a new player object$/ do
  @player = mock
  @player.stubs(:name).returns('First')
  @player.stubs(:game_object_id).returns('first_player_id')
  @player.stubs(:to_s).returns('first_player_id')
end

Then /^the player should have been notified that he entered a map$/ do
  @player_msg.should eql 'Entering game map TestMap at location [0, 0, 0]'
end

Given /^a second player object$/ do
  @second_player = mock
  @second_player.stubs(:name).returns('Second')
  @second_player.stubs(:game_object_id).returns('second_player_id')
  @second_player.stubs(:to_s).returns('second_player_id')
end

Given /^the second player in the start location$/ do
  @second_player.expects(:location=).once.with(is_a(Array))
  @second_player.expects(:location).once.returns([0,0,0])
  @second_player.expects(:map=).once.with(@map.game_object_id) {|obj_id| obj_id == @map.game_object_id}
  @second_player.expects(:save).once
  @second_player.expects(:send_to_client).twice.with(is_a(String)) { |msg|@second_player_msg ||= []; @second_player_msg << msg }
  @map.enter @second_player
end

Then /^the other player should have been notified too$/ do
  @second_player_msg.should include 'First has entered the map.'
end

When /^calculating directions for new location "([^"]*)" and old location "([^"]*)"$/ do |new_location, old_location|
  the_new_location = eval(new_location) unless new_location.nil? or new_location.empty?
  the_old_location = eval(old_location) unless old_location.nil? or old_location.empty?

  @movement_direction = @map.calc_movement_direction the_new_location, the_old_location
end

Then /^the text directions should be "([^"]*)"$/ do |directions|
  @movement_direction.should eql directions
end

When /^a player enters the room at "([^"]*)"$/ do |location|
  the_location = eval(location) unless location.nil? or location.empty?

  @player.expects(:location=).once.with(the_location) {|location| location == the_location}
  @map.enter_room @player, the_location
end

When /^a second player enters the room at "([^"]*)" from "([^"]*)"$/ do |new_location, old_location|
  the_new_location = eval(new_location) unless new_location.nil? or new_location.empty?
  the_old_location = eval(old_location) unless old_location.nil? or old_location.empty?

  @second_player.expects(:location=).once.with(the_new_location) {|location| location = the_new_location}
  @player.expects(:send_to_client).once.with(is_a(String)) {|msg| @player_msg = msg}
  @map.enter_room @second_player, the_new_location, the_old_location
end

Then /^the player should have been sent the message "([^"]*)"$/ do |msg|
  @player_msg.should eql msg
end